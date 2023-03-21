locals {
  name = "lambda-${var.base_name}"
  tags = {
    Environment = "Test"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
    Resource    = local.name
  }
}

resource "aws_lambda_function" "lambda_example" {
  function_name = local.name
  description   = "My first lambda function :)."
  handler       = var.lambda_class_name
  runtime       = "java11"
  timeout       = 15
  memory_size   = 512

  s3_bucket = var.s3_bucket_id
  s3_key    = aws_s3_object.s3_object_lambda.key


  role = var.lab_role_arn != "" ? var.lab_role_arn : aws_iam_role.lambda_exec_role[0].arn

  source_code_hash = filebase64sha256(var.lambda_source_file)
  tags             = merge(local.tags, { Type = "Lambda" })
}

resource "aws_s3_object" "s3_object_lambda" {
  bucket = var.s3_bucket_id
  key    = "${local.name}.jar"
  source = var.lambda_source_file
  etag   = filemd5(var.lambda_source_file)
  tags   = local.tags
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_example.function_name}"
  retention_in_days = 14
}

#########################################################
#The resources below will not be used because of LabRole.
#########################################################
resource "aws_iam_role" "lambda_exec_role" {
  count = var.lab_role_arn == "" ? 1 : 0
  name  = "lambda-role-${var.base_name}"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSLambdaExecute",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    #      ,aws_iam_policy.lambda_policy.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:HeadBucket"]
      Resource = [var.s3_bucket_arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = [aws_s3_object.s3_object_lambda.acl]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_att" {
  count      = var.lab_role_arn == "" ? 1 : 0
  role       = aws_iam_role.lambda_exec_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# resource "aws_iam_policy" "lambda_policy" {
#   name = "lambda-policy-${local.name}"
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
