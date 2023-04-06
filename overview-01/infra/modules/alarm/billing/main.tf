locals {
  name = "Billing_Alert"
}

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name        = local.name
  alarm_description = "Alarm for billing."
  type              = "Metric alarm"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60 * 60 * 24 #1 day
  unit                = "Count"

  namespace   = "AWS/Billing"
  metric_name = "EstimatedCharges"
  statistic   = "Maximum"

  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"


  dimensions = {
    Currency = "USD"
  }

  #slack integration
  alarm_actions = [var.sns_arn]
  ok_actions    = [var.sns_arn]

  tags = var.tags
}


#View EventBridge rule
#Use EventBridge to respond when the alarm changes state. Copy this Custom Event Pattern and use it when creating your EventBridge Rule. 
#You can use this as a starting point for more advanced Event Patterns. info

#{
#  "source": [
#    "aws.cloudwatch"
#  ],
#  "detail-type": [
#    "CloudWatch Alarm State Change"
#  ],
#  "resources": [
#    "arn:aws:cloudwatch:us-east-1:517642288749:alarm:Billing_Alert"
#  ]
#}
