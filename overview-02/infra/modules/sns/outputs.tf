# Output value definitions

output "sns_email_arn" {
  description = "ARN of the email SNS."
  value       = aws_sns_topic.email_alarm_topic.arn
}
