# Output value definitions

output "lambda_function_arn" {
  description = "ARN of the lambda function."
  value       = module.lambda_dynamoDB.lambda_function_arn
}

output "s3_bucket_id" {
  description = "Id of the S3 bucket."
  value       = module.lambda_bucket.s3_bucket_id
}
