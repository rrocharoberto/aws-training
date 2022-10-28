# Input variable definitions

variable "base_name" {
  description =  "Base name to use in the resources name."
  type        = string
}

variable "lab_role_arn" {
  description =  "ARN of the role already created to use."
  type        = string
}
