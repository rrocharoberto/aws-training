# Input variable definitions

variable "base_name" {
  description = "Base name to use in the lambda name."
  type        = string
}

variable "resource_name" {
  description = "Base URL of the resource endpoint."
  type        = string
}

variable "api_name" {
  description = "Name of the API Gateway."
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage."
  type        = string
}

variable "sns_arn" {
  description = "ARN of the SNS to send alarm messages."
  type        = string
}

variable "tags" {
  description = "A mapping of default tags to assign to the resources"
  type        = map(string)
  default     = {}
}
