# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
}

variable "email_recipient" {
  description = "Email to receive the SNS messages."
  type        = string
}
