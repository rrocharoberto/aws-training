# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "service_name" {
  description = "Name of the service."
  type        = string
}

variable "environment" {
  description = "Environment of deployment."
  type        = string
}

variable "email_recipient" {
  description = "Email to receive the SNS messages."
  type        = string
}

variable "lab_role_arn" {
  description = "ARN of the role already created to use."
  type        = string
  default     = ""
}