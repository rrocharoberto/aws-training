# Output value definitions

output "api_name" {
  description = "Name of the API Gateway."
  value       = aws_api_gateway_rest_api.api_gateway_rest_api.name
}

output "invoke_url" {
  description = "URL of the API Gateway."
  value       = aws_api_gateway_stage.api_stage.invoke_url
}
