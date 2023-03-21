locals {
  name = "dlq-lambda-03"
  #  name = "dlq-${var.base_name}"
  tags = {
    Environment = "Test"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
    Resource    = local.name
  }
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = local.name
  tags = merge(local.tags, { Type = "dlq" })
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_binder" {
  event_source_arn = resource.aws_sqs_queue.dead_letter_queue.arn
  function_name    = var.destination_lambda_arn
  batch_size       = 1
}

data "aws_caller_identity" "current" {}
