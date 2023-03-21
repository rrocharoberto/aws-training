# Output value definitions

output "s3_bucket_id" {
  description = "Id of the S3 bucket."
  value       = aws_s3_bucket.lambda_bucket.id
}

output "lambda_function_arn" {
  description = "ARN of the lambda function."
  value       = aws_lambda_function.lambda_example_01.arn
}
