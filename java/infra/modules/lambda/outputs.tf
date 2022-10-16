# Output value definitions

output "lambda_function_name" {
  description =  "Name of the lambda function."
  value       = aws_lambda_function.lambda_hello_world.function_name
}
