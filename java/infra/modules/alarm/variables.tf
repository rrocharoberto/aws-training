# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the lambda function."
  type        = string
}

variable "sns_arn" {
  description = "ARN of the SNS to send alarm messages."
  type        = string
  default     = ""
}
