# Input variable definitions

variable "service_name" {
  description = "Name of the service."
  type        = string
}

variable "environment" {
  description = "Environment of deployment."
  type        = string
}

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

variable "lambda_bucket_id" {
  description = "Id of the S3 bucket."
  type        = string
}

variable "message_table_arn" {
  type        = string
  description = "Arn of the Message table"
  default     = ""
}

variable "tags" {
  description = "A mapping of default tags to assign to the resources"
  type        = map(string)
  default     = {}
}
