# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "sns_arn" {
  description = "ARN of the SNS to send alarm messages."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of default tags to assign to the resources"
  type        = map(string)
  default     = {}
}