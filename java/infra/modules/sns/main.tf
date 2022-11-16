locals {
  sns_name = "email-sns-${var.base_name}"
  tags = {
    Environment = "Test"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
  }
}

resource "aws_sns_topic" "email_alarm_topic" {
  name = local.sns_name
  tags = merge(local.tags, { Type = "SNS", Resource = local.sns_name })
}

resource "aws_sns_topic_subscription" "sqs_email_subscription" {
  topic_arn = aws_sns_topic.email_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email_recipient
}
