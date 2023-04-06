locals {
  name = "sqs-${var.base_name}"
}

resource "aws_sqs_queue" "sqs_example" {
  name                      = local.name
  delay_seconds             = 10
  max_message_size          = 1024
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  redrive_policy = jsonencode({
    deadLetterTargetArn = var.dead_letter_queue_arn
    maxReceiveCount     = 2
  })

  tags = var.tags
}

##### SQS role #####
resource "aws_iam_role" "sqs_role" {
  name               = "sqs_role-${var.base_name}"
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

#Attach the SQS as a source event of the lambda
resource "aws_lambda_event_source_mapping" "sqs_lambda_binder" {
  event_source_arn = aws_sqs_queue.sqs_example.arn
  function_name    = var.destination_lambda_arn
  batch_size       = 1
}

##### SQS policy to send and receive messages #####
resource "aws_sqs_queue_policy" "sqs_unencrypted_policy" {
  queue_url = aws_sqs_queue.sqs_example.url
  policy    = data.aws_iam_policy_document.sqs_policy_doc.json
}

data "aws_iam_policy_document" "sqs_policy_doc" {
  statement {
    actions   = ["SQS:SendMessage", "SQS:ReceiveMessage"]
    resources = [aws_sqs_queue.sqs_example.arn]
    effect    = "Allow"
  }
}

### Lambda permission to access SQS ###
resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = local.name
  description = "Allow lambda execution role access SQS"
  policy      = data.aws_iam_policy_document.lambda_sqs_policy_doc.json
  tags        = var.tags
}

# Attach the SQS policy to the lambda role.
resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
  role       = var.lambda_role_id
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

data "aws_iam_policy_document" "lambda_sqs_policy_doc" {
  statement {
    effect    = "Allow"
    resources = compact([aws_sqs_queue.sqs_example.arn])
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
  }
}
