locals {
  name = "lambda-dynamo-policy-${var.base_name}"
}

# Attach the dynamo policy to the lambda role.
resource "aws_iam_role_policy_attachment" "lambda_dynamo_policy_attachment" {
  role       = var.lambda_role_id
  policy_arn = aws_iam_policy.lambda_dynamo_policy.arn
}

resource "aws_iam_policy" "lambda_dynamo_policy" {
  name        = local.name
  description = "Allow lambda execution role access DynamoDB table"
  policy      = data.aws_iam_policy_document.lambda_dynamodb_policy_doc.json
  tags        = var.tags
}

data "aws_iam_policy_document" "lambda_dynamodb_policy_doc" {
  statement {
    effect    = "Allow"
    resources = compact([var.dynamo_table_arn, format("%s/index/*", var.dynamo_table_arn)])
    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
  }
}