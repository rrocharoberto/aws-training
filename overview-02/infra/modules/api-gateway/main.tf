locals {
  name = "rest-api-${var.base_name}"
}

resource "aws_apigatewayv2_api" "api_gateway_rest_api" {
  name          = local.name
  protocol_type = "HTTP"
  tags          = var.tags
}

resource "aws_apigatewayv2_stage" "api_gw_stage" {
  name        = var.stage_name
  api_id      = aws_apigatewayv2_api.api_gateway_rest_api.id
  auto_deploy = true
  tags        = var.tags
}

resource "aws_apigatewayv2_deployment" "api_gw_deployment" {
  api_id      = aws_apigatewayv2_api.api_gateway_rest_api.id
  description = "API Gateway deployment"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_apigatewayv2_integration.api_gw_integration_get,
    aws_apigatewayv2_integration.api_gw_integration_post
  ]
}

#GET
resource "aws_apigatewayv2_integration" "api_gw_integration_get" {
  api_id = aws_apigatewayv2_api.api_gateway_rest_api.id

  integration_uri    = var.lambda_function_arn
  integration_type   = "AWS_PROXY"
  integration_method = "GET"
}

resource "aws_apigatewayv2_route" "get_route_get" {
  api_id    = aws_apigatewayv2_api.api_gateway_rest_api.id
  route_key = "GET ${var.resource_url}"
  target    = "integrations/${aws_apigatewayv2_integration.api_gw_integration_get.id}"
}

#POST
resource "aws_apigatewayv2_integration" "api_gw_integration_post" {
  api_id = aws_apigatewayv2_api.api_gateway_rest_api.id

  integration_uri    = var.lambda_function_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_route_post" {
  api_id    = aws_apigatewayv2_api.api_gateway_rest_api.id
  route_key = "POST ${var.resource_url}"
  target    = "integrations/${aws_apigatewayv2_integration.api_gw_integration_post.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_lg" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.api_gateway_rest_api.name}"

  retention_in_days = 30
  tags              = var.tags
}

resource "aws_lambda_permission" "api_gw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway_rest_api.execution_arn}/*/*"
}
