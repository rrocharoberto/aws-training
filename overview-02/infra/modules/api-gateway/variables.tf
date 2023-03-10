# Input variable definitions

variable "base_name" {
  description = "Base name to use in the lambda name."
  type        = string
}

variable "resource_url" {
  description = "Base URL of the resource endpoint."
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage."
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