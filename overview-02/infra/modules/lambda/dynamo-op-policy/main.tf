
### Lambda permission to access DynamoDB ###
resource "aws_iam_policy" "lambda_dynamo_operation_policy" {
  name        = "lambda-dynamo-op-policy-${var.base_name}"
  description = "Allow lambda execution role access DynamoDB table"
  policy      = data.aws_iam_policy_document.lambda_dynamodb_operation_policy_doc.json
  tags        = var.tags
}

# Attach the dynamo policy to the lambda role.
resource "aws_iam_role_policy_attachment" "lambda_dynamo_operation_policy_attachment" {
  role       = var.lambda_role_id
  policy_arn = aws_iam_policy.lambda_dynamo_operation_policy.arn
}

data "aws_iam_policy_document" "lambda_dynamodb_operation_policy_doc" {
  statement {
    effect    = "Allow"
    resources = compact([var.dynamo_table_arn, format("%s/index/*", var.dynamo_table_arn)])
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
  }
}
