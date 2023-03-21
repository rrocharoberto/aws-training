# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "lambda_source_file" {
  description = "Path to the file that contains the lambda code."
  type        = string
}

variable "lambda_class_name" {
  description = "Full name of the lambda class."
  type        = string
}

variable "s3_bucket_id" {
  description = "Id of the S3 bucket."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket."
  type        = string
}

variable "lab_role_arn" {
  description = "ARN of the role already created to use."
  type        = string
}
