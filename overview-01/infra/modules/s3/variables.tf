# Input variable definitions

variable "base_name" {
  description = "Base name to use in the resources name."
  type        = string
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
