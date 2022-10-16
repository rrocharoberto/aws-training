# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "base_name" {
  description =  "Base name to use in the lambda name."
  type        = string
}

variable "lambda_source_file" {
  description =  "Path to the file that contains the lambda code."
  type        = string
}

variable "lab_role_arn" {
  description =  "ARN of the role already created to use."
  type        = string
}
