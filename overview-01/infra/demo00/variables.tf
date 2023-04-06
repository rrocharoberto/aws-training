# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "service_name" {
  description = "Name of the service."
  type        = string
}

variable "environment" {
  description = "Environment of deployment."
  type        = string
}

#Slack variables
variable "slack_hook_url" {
  description = "URl of Slack hook which will receive the SNS messages."
  type        = string
}

variable "slack_channel" {
  description = "Name of Slack channel which will receive the SNS messages."
  type        = string
}
