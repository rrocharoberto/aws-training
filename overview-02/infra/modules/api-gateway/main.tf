locals {
  name = "rest-api-${var.base_name}"
  redeployment_trigger = md5(format("%s%s%s",
    file("${path.module}/main.tf"),
    var.resource_name,
    var.lambda_function_invoke_arn
    )
  )
}

resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  name = local.name
  tags = var.tags
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  depends_on    = [aws_cloudwatch_log_group.api_log_group]
  tags          = var.tags
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  description = "API Gateway deployment"
  triggers = {
    redeployment = local.redeployment_trigger
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_integration.api_integration_get,
    aws_api_gateway_integration.api_integration_post
  ]
}

#RESOURCE
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_rest_api.root_resource_id
  path_part   = var.resource_name
}

#GET
resource "aws_api_gateway_method" "api_method_get" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.api_method_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST" #API Gateway --> Lambda
  uri                     = var.lambda_function_invoke_arn
}

#POST
resource "aws_api_gateway_method" "api_method_post" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.api_method_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_function_invoke_arn
}

#LOG GROUP
resource "aws_cloudwatch_log_group" "api_log_group" {
  name = "/aws/api_gw/${aws_api_gateway_rest_api.api_gateway_rest_api.name}"

  retention_in_days = 30
  tags              = var.tags
}

#LAMBDA PERMISSION
resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway_rest_api.execution_arn}/*/*"
}
