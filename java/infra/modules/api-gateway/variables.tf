# Input variable definitions

variable "base_name" {
  description = "Base name to use in the lambda name."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the lambda function associated with the API Gateway."
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the lambda function."
  type        = string
}

variable "lab_role_arn" {
  description = "ARN of the role already created to use."
  type        = string
}
