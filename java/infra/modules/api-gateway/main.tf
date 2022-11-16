resource "aws_apigatewayv2_api" "api_gw_rest_api" {
  name          = "rest-api-${var.base_name}"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "api_gw_stage" {
  api_id = aws_apigatewayv2_api.api_gw_rest_api.id

  name        = "serverless_api_gw_stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "api_gw_integration" {
  api_id = aws_apigatewayv2_api.api_gw_rest_api.id

  integration_uri    = var.lambda_function_arn
  integration_type   = "AWS_PROXY"
  integration_method = "GET"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.api_gw_rest_api.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.api_gw_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_lg" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.api_gw_rest_api.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gw_rest_api.execution_arn}/*/*"
}
