locals {
  name = "alarm-${var.base_name}"
}
# API Gateway Alarms
resource "aws_cloudwatch_metric_alarm" "post_4xx_alarm" {
  alarm_name        = "4xx-${local.name}"
  alarm_description = "Alarm for API Gateway POST 4xx errors."

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 0
  period              = 60 #1 minute
  unit                = "Count"

  namespace   = "AWS/ApiGateway"
  metric_name = "4XXError"
  statistic   = "Sum"

  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    Resource = "/${var.resource_name}"
    Method   = "POST"
    Stage    = var.stage_name
    ApiName  = var.api_name
  }

  #slack integration
  alarm_actions = [var.sns_arn]
  ok_actions    = [var.sns_arn]

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "post_5xx_alarm" {
  alarm_name        = "5xx-${local.name}"
  alarm_description = "Alarm for API Gateway POST 5xx errors."

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 0
  period              = 60 #1 minute
  unit                = "Count"

  namespace   = "AWS/ApiGateway"
  metric_name = "5XXError"
  statistic   = "Sum"

  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    Resource = "/${var.resource_name}"
    Method   = "POST"
    Stage    = var.stage_name
    ApiName  = var.api_name
  }

  #slack integration
  alarm_actions = [var.sns_arn]
  ok_actions    = [var.sns_arn]

  tags = var.tags
}
