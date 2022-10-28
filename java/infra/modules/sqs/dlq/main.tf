
##### DLQ configuration #####
#####

resource "aws_sqs_queue" "dead_letter_queue" {
#  name = "dlq-${var.base_name}"
  name = "dlq-lambda-03"
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_binder" {
  event_source_arn = resource.aws_sqs_queue.dead_letter_queue.arn
  function_name    = var.dlq_lambda_arn
  batch_size       = 1
}

data "aws_caller_identity" "current" {}
