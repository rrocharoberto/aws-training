terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Roberto Rocha"
      BuildNumber = random_pet.base_name.id
    }
  }
}

resource "random_pet" "base_name" {
  prefix = "aws-training-"
  length = 4
}

resource "aws_lambda_function" "lambda_hello_world" {
  function_name = "lambda-${random_pet.base_name.id}"
  description   = "My first lambda function :)."
  handler       = "com.roberto.aws.lambda.FunctionHello"
  runtime       = "java11"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello_world.key

  source_code_hash = data.archive_file.file_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec_role.arn
  tags = {
      Name   = "lambda-${random_pet.base_name.id}"
      Type   = "Lambda"
  }
}

data "archive_file" "file_hello_world" {
  type = "zip"
  source_file = "${path.module}/../app/lambda01/target/lambda01-0.1.jar"
  output_path = "${path.module}/hello-world.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "bucket-${random_pet.base_name.id}"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.file_hello_world.output_path

  etag = filemd5(data.archive_file.file_hello_world.output_path)
}

resource "aws_cloudwatch_log_group" "hello_world_lg" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_hello_world.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_att" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
