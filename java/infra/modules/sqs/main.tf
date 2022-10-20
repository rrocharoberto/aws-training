
##### Main Queue configuration #####
#####
resource "aws_sqs_queue" "sqs_example" {
  name                      = "sqs-${var.base_name}"
  delay_seconds             = 10
  max_message_size          = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Name   = "lambda-${var.base_name}"
    Type = "sqs"
  }
}

resource "aws_iam_role" "sqs_role" {
  count = var.lab_role_arn == "" ? 1 : 0
  name  = "sqs_role-${var.base_name}"

  assume_role_policy = data.aws_iam_policy_document.sqs_assume_role_policy.json
}

data "aws_iam_policy_document" "sqs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_binder" {
  event_source_arn = aws_sqs_queue.sqs_example.arn
  function_name    = var.destination_lambda_arn
  batch_size       = 1
}

resource "aws_sqs_queue_policy" "sqs_unencrypted_policy" {
  queue_url = aws_sqs_queue.sqs_example.url
  policy    = data.aws_iam_policy_document.sqs_policy_doc.json
}

data "aws_iam_policy_document" "sqs_policy_doc" {
  # "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  statement {
    actions   = ["SQS:SendMessage", "SQS:ReceiveMessage"]
    resources = [aws_sqs_queue.sqs_example.arn]
    effect    = "Allow"
  }
}

data "aws_caller_identity" "current" {}
