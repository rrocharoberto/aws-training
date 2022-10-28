# Input variable definitions

variable "base_name" {
  description = "Base name to use in the lambda name."
  type        = string
}

variable "lab_role_arn" {
  description = "ARN of the role already created to use."
  type        = string
}

variable "dlq_lambda_arn" {
  description = "ARN of the DLQ lambda that will receive DQL messages."
  type        = string
}
