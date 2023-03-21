# Output value definitions

output "sns_slack_arn" {
  description = "ARN of the slack channel SNS."
  value       = aws_sns_topic.slack_alarm_topic.arn
}
