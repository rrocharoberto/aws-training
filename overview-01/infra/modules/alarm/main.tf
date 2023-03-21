locals {
  name = "alarm-${var.base_name}"
}

resource "aws_cloudwatch_metric_alarm" "lambda_alarm" {
  alarm_name        = local.name
  alarm_description = "Alarm for lambda errors."

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 0
  period              = 60 #1 minute
  unit                = "Count"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  statistic   = "Sum"

  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  #slack integration
  alarm_actions = [var.sns_arn]
  ok_actions    = [var.sns_arn]

  tags = var.tags
}
