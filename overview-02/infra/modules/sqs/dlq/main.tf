locals {
  name = "dlq-${var.base_name}"
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = local.name
  tags = var.tags
}

#Attach the DLQ as a source event of the lambda
resource "aws_lambda_event_source_mapping" "dlq_lambda_binder" {
  event_source_arn = resource.aws_sqs_queue.dead_letter_queue.arn
  function_name    = var.destination_lambda_arn
  batch_size       = 1
}

### Lambda permission to access DLQ ###
resource "aws_iam_policy" "lambda_dlq_policy" {
  name        = local.name
  description = "Allow lambda execution role access DLQ"
  policy      = data.aws_iam_policy_document.lambda_dlq_policy_doc.json
  tags        = var.tags
}

# Attach the DLQ policy to the lambda role.
resource "aws_iam_role_policy_attachment" "lambda_dlq_policy_attachment" {
  role       = var.lambda_role_id
  policy_arn = aws_iam_policy.lambda_dlq_policy.arn
}

data "aws_iam_policy_document" "lambda_dlq_policy_doc" {
  statement {
    effect    = "Allow"
    resources = [aws_sqs_queue.dead_letter_queue.arn]
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
  }
}
