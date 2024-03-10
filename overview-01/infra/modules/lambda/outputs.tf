# Output value definitions

output "lambda_function_name" {
  description = "Name of the lambda function."
  value       = aws_lambda_function.lambda_example.function_name
}

output "lambda_function_arn" {
  description = "ARN of the lambda function."
  value       = aws_lambda_function.lambda_example.arn
}

output "lambda_function_invoke_arn" {
  description = "ARN of the lambda function."
  value       = aws_lambda_function.lambda_example.invoke_arn
}

output "lambda_role_id" {
  description = "Id of the lambda role."
  value       = var.lab_role_arn == "" ? aws_iam_role.lambda_role[0].id : "LabRole"
}
