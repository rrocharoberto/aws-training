locals {
  lambda_name = "lambda-${var.base_name}"
}

resource "aws_lambda_function" "lambda_example" {
  function_name = "lambda-${var.base_name}"
  description   = "My first lambda function :)."
  handler       = var.lambda_class_name
  runtime       = "java11"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.s3_object_lambda.key

  source_code_hash = filebase64sha256(var.lambda_source_file)

  role = var.lab_role_arn != "" ? var.lab_role_arn : aws_iam_role.lambda_exec_role[0].arn
  tags = {
    Name   = local.lambda_name
    Type   = "Lambda"
  }
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "bucket-${var.base_name}"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "s3_object_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "${local.lambda_name}.jar"
  source = var.lambda_source_file
  etag   = filemd5(var.lambda_source_file)
}

resource "aws_cloudwatch_log_group" "lambda_lg" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_example.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec_role" {
  count = var.lab_role_arn == "" ? 1 : 0
  name = "lambda-role-${var.base_name}"

  managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonS3FullAccess",
      "arn:aws:iam::aws:policy/AWSLambdaExecute", 
      "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#      ,aws_iam_policy.lambda_policy.arn
    ]
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:HeadBucket"]
        Resource = [aws_s3_bucket.lambda_bucket.arn]
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = [aws_s3_object.s3_object_lambda.acl]
      },
    ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_att" {
  count = var.lab_role_arn == "" ? 1 : 0
  role       = aws_iam_role.lambda_exec_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# resource "aws_iam_policy" "lambda_policy" {
#   name = "lambda-policy-${local.base_name}"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:HeadBucket"],
#         Effect   = "Allow",
#         Resource = "*"
#       },
#     ]
#   })
# }
