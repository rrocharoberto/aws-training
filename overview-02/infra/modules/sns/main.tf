resource "aws_sns_topic" "sns_topic" {
  name = "sns-${var.base_name}"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "sqs_lambda_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "lambda"
  endpoint  = var.lambda_function_arn
}
