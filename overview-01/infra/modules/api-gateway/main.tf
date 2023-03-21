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

#ERROR HANDLING
resource "aws_api_gateway_model" "error_output_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_gateway_rest_api.id
  name         = "ErrorOutputModel"
  description  = "a JSON schema for the error model"
  content_type = "application/json"

  schema = templatefile("${path.module}/models/ErrorOutputModel.tmpl", {
    api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  })
}

resource "aws_api_gateway_method_response" "message_post_error_response" {
  for_each        = toset(["400", "403", "500", "502"])
  rest_api_id     = aws_api_gateway_rest_api.api_gateway_rest_api.id
  resource_id     = aws_api_gateway_resource.resource.id
  http_method     = aws_api_gateway_method.api_method_post.http_method
  status_code     = each.key
  response_models = { "application/json" = aws_api_gateway_model.error_output_model.name }
  depends_on      = [aws_api_gateway_model.error_output_model]
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

resource "aws_api_gateway_method_settings" "general_settings" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true #https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-metrics-and-dimensions.html
  }
}