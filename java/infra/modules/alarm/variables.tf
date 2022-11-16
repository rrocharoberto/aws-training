# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the lambda function."
  type        = string
}

variable "sns_slack_arn" {
  description = "ARN of the slack SNS chanel configuration."
  type        = string
  default     = ""
}
