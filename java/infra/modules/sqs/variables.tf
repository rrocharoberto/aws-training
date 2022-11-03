# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "destination_lambda_arn" {
  description = "ARN of the lambda function that will receive the messages from the queue."
  type        = string
}

variable "dead_letter_queue_arn" {
  description = "ARN of the dead letter queue."
  type        = string
}

variable "lab_role_arn" {
  description = "ARN of the role already created to use."
  type        = string
}
