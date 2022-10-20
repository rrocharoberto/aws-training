# Output value definitions

output "lambda_function_name" {
  description =  "Name of the lambda function."
  value       = aws_lambda_function.lambda_example.function_name
}

output "lambda_function_arn" {
  description =  "ARN of the lambda function."
  value       = aws_lambda_function.lambda_example.arn
}
