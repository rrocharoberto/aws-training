locals {
  base_name = "${var.service_name}-${random_integer.base_number.id}"

  lambda_source_file = "${path.module}/../app/lambda-01/lambda_function.py"
  lambda_method_name = "lambda_function.lambda_handler"
  lambda_zip_file    = "${local.base_name}.zip"

  tags = {
    Environment = var.environment
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
  }
}

##### S3 Bucket resources #####
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "bucket-${local.base_name}"
  tags   = local.tags
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

##### Lambda resources #####
data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = local.lambda_source_file
  output_path = local.lambda_zip_file
}

resource "aws_lambda_function" "lambda_example_01" {
  function_name = local.base_name
  description   = "My first lambda function :)."

  runtime = "python3.8"
  handler = local.lambda_method_name
  role    = aws_iam_role.lambda_role.arn
  timeout = 10

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.s3_object_lambda.key

  environment {
    variables = {
      SERVICE     = var.service_name
      ENVIRONMENT = var.environment
    }
  }

  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  tags             = local.tags
}

resource "aws_s3_object" "s3_object_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = local.lambda_zip_file
  source = data.archive_file.python_lambda_package.output_path
  etag   = filemd5(local.lambda_zip_file)
  tags   = local.tags
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_example_01.function_name}"
  retention_in_days = 14
}

##### Lambda role #####
resource "aws_iam_role" "lambda_role" {
  name               = "lambdaRole-${local.base_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags               = local.tags
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
