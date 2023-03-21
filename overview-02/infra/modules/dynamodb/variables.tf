# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "destination_lambda_arn" {
  description = "ARN of the lambda function that will receive the messages from the DynamoDB stream."
  type        = string
}

variable "lab_role_arn" {
  description = "ARN of the role already created to use."
  type        = string
}
