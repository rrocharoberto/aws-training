# Output value definitions

output "s3_bucket_id" {
  description = "Id of the S3 bucket."
  value       = aws_s3_bucket.lambda_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = aws_s3_bucket.lambda_bucket.arn
}
