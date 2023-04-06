
# Set DynamoDB stream as a source of the lambda
resource "aws_lambda_event_source_mapping" "lambda_dynamo_mapping" {
  event_source_arn       = var.dynamo_table_stream_arn
  function_name          = var.destination_lambda_arn
  starting_position      = "LATEST"
  batch_size             = 1
  maximum_retry_attempts = 2
}

### Lambda permission to access stream ###
resource "aws_iam_policy" "lambda_dynamo_stream_policy" {
  name        = "lambda-dynamo-stream-policy-${var.base_name}"
  description = "Allow lambda execution role access DynamoDB table"
  policy      = data.aws_iam_policy_document.lambda_dynamodb_stream_policy_doc.json
  tags        = var.tags
}

# Attach the dynamo policy to the lambda role.
resource "aws_iam_role_policy_attachment" "lambda_dynamo_stream_policy_attachment" {
  role       = var.lambda_role_id
  policy_arn = aws_iam_policy.lambda_dynamo_stream_policy.arn
}

data "aws_iam_policy_document" "lambda_dynamodb_stream_policy_doc" {
  statement {
    effect    = "Allow"
    resources = compact(["${var.dynamo_table_arn}/stream/*"])
    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream"
    ]
  }
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["dynamodb:ListStreams"]
  }
}
