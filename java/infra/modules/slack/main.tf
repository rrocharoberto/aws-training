locals {
  sns_name   = "slack-sns-${var.base_name}.fifo"
  slack_name = "slack-${var.base_name}"
  tags = {
    Environment = "Test"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
  }

  slack_workspace_id = "<WORKSPACE_ID_TO_FIX>"
  slack_channel_id   = "<CHANNEL_ID_TO_FIX"

  guardrail_policies    = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  chatbot_logging_level = "INFO"
}

resource "aws_sns_topic" "slack_alarm_topic" {
  name       = local.sns_name
  fifo_topic = true
  tags       = merge(local.tags, { Type = "SNS", Resource = local.sns_name })
}

resource "aws_cloudformation_stack" "chatbot_slack_configuration" {
  name = local.slack_name

  iam_role_arn = var.lab_role_arn
  template_body = templatefile("${path.module}/cloudformation.json", {
    ConfigurationNameParameter = local.slack_name
    IamRoleArnParameter        = var.lab_role_arn
    LoggingLevelParameter      = local.chatbot_logging_level
    SlackChannelIdParameter    = local.slack_channel_id
    SlackWorkspaceIdParameter  = local.slack_workspace_id
    SnsTopicArnsParameter      = join(",", [aws_sns_topic.slack_alarm_topic.arn])
  })

  tags = merge(local.tags, { Type = "CloudFormation", Resource = local.slack_name })
}

# resource "awscc_chatbot_slack_channel_configuration" "slack_chat_bot_channel" {
#   configuration_name = local.name
#   iam_role_arn       = var.lab_role_arn
#   slack_channel_id   = local.slack_channel_id
#   slack_workspace_id = local.slack_workspace_id
#   sns_topic_arns     = [aws_sns_topic.slack_alarm_topic.arn]
# }
