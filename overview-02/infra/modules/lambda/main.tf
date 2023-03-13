locals {
  name            = "lambda-${var.base_name}"
  lambda_zip_file = "${var.base_name}.zip"
  env_vars = {
    SERVICE     = var.service_name
    ENVIRONMENT = var.environment
  }
}

##### Lambda resources #####
resource "aws_lambda_function" "lambda_example" {
  function_name = local.name
  description   = "My first lambda function :)."
  handler       = var.lambda_handler
  runtime       = var.runtime
  timeout       = 15
  memory_size   = 512

  s3_bucket = var.lambda_bucket_id
  s3_key    = aws_s3_object.s3_object_lambda.key

  environment {
    variables = var.env_vars == null ? local.env_vars : merge(local.env_vars, var.env_vars)
  }

  role = aws_iam_role.lambda_role.arn

  source_code_hash = filebase64sha256(var.lambda_source_file)
  tags             = var.tags
}

resource "aws_s3_object" "s3_object_lambda" {
  bucket = var.lambda_bucket_id
  key    = var.s3_object_name
  source = var.lambda_source_file
  etag   = filemd5(var.lambda_source_file)
  tags   = var.tags
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_example.function_name}"
  retention_in_days = 14
}

##### Lambda role #####
resource "aws_iam_role" "lambda_role" {
  name               = "lambdaAssumeRole-${var.base_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags               = var.tags
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Attach the logging policy to the lambda role.
resource "aws_iam_role_policy_attachment" "lambda_log_policy_attachment" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_policy" "lambda_log_policy" {
  name        = "lambdaLogPolicy-${var.base_name}"
  description = "Allow lambda execution role access to CloudWatch logs"
  policy      = data.aws_iam_policy_document.lambda_log_policy_doc.json
  tags        = var.tags
}

data "aws_iam_policy_document" "lambda_log_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
