locals {
  sns_name = "email-sns-${var.base_name}"
}

resource "aws_sns_topic" "sns_alarm_topic" {
  name = local.sns_name
  tags = var.tags
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.sns_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email_recipient
}
