# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "lambda_role_id" {
  description = "The Id of the IAM role of the lambda to which the policy should be applied."
  type        = string
}

variable "dynamo_table_arn" {
  type        = string
  description = "Arn of the dynamodb table"
}

variable "tags" {
  description = "A mapping of default tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "lab_role_arn" {
  description = "ARN of the LabRole already created to use."
  type        = string
  default     = ""
}
