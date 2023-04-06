# Input variable definitions

variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "tags" {
  description = "A mapping of default tags to assign to the resources"
  type        = map(string)
  default     = {}
}
