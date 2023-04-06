# Output value definitions

output "s3_bucket_id" {
  description = "Id of the S3 bucket."
  value       = module.s3_bucket_lambdas.s3_bucket_id
}