# Input variable definitions

variable "base_name" {
  description = "Base name to use in the lambda name."
  type        = string
}

variable "destination_lambda_arn" {
  description = "ARN of the lambda that will receive messages from DLQ."
  type        = string
}

variable "lambda_role_id" {
  description = "The Id of the IAM role of the lambda to which the policy should be applied."
  type        = string
}

variable "tags" {
  description = "A mapping of default tags to assign to the resources"
  type        = map(string)
  default     = {}
}
