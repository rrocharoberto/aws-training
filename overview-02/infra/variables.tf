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
