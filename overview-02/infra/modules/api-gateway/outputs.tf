# Output value definitions

output "invoke_url" {
  description = "URL of the API Gateway."
  value       = aws_apigatewayv2_stage.api_gw_stage.invoke_url
}
