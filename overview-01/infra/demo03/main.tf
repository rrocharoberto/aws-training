locals {
  base_name = "${var.environment}-${var.service_name}-${random_integer.base_number.id}"

  lambda02_source_file = "${path.module}/../../app/lambda-02/target/lambda-02-0.1.jar"
  lambda02_handler     = "com.roberto.aws.lambda.MessageController"
  lambda02_jar         = "lambda-02.jar"

  lambda03_source_file = "${path.module}/../../app/lambda-03/lambda_slack.py"
  lambda03_handler     = "lambda_slack.lambda_handler"
  lambda03_zip         = "lambda-03.zip"

  message_table_name = "${var.environment}-message-table"

  tags = {
    Environment = var.environment
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
  }
}

module "s3_bucket_lambdas" {
  source    = "../modules/s3"
  base_name = local.base_name
  tags      = local.tags
}

module "lambda_dynamoDB" {
  source    = "../modules/lambda"
  base_name = "02-${local.base_name}"
  runtime   = "java11"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = local.lambda02_source_file
  lambda_handler     = local.lambda02_handler
  s3_object_name     = local.lambda02_jar

  env_vars = {
    MESSAGE_DYNAMODB_TABLE_NAME = local.message_table_name
  }

  tags = local.tags
}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = local.lambda03_source_file
  output_path = local.lambda03_zip
}

module "lambda_slack" {
  source         = "../modules/lambda"
  base_name      = "03-${local.base_name}"
  lambda_handler = local.lambda03_handler
  runtime        = "python3.8"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = data.archive_file.python_lambda_package.output_path
  s3_object_name     = local.lambda03_zip

  env_vars = {
    #export TF_VAR_slack_hook_url=<your_slack_hook_url_here>
    SLACK_HOOK_URL = var.slack_hook_url
    SLACK_CHANNEL  = var.slack_channel
  }

  tags = local.tags
}

module "lambda_dynamo_attachment" {
  source           = "../modules/lambda/dynamo-policy"
  base_name        = "02-${local.base_name}"
  lambda_role_id   = module.lambda_dynamoDB.lambda_role_id
  dynamo_table_arn = module.dynamodb.dynamodb_table_arn
  tags             = local.tags
}

module "dynamodb" {
  source     = "../modules/dynamodb"
  base_name  = var.service_name
  table_name = local.message_table_name
  tags       = local.tags
}

module "api_gateway" {
  source        = "../modules/api-gateway"
  base_name     = local.base_name
  resource_name = "message"
  stage_name    = "stage-${var.service_name}-${var.environment}"

  lambda_function_name       = module.lambda_dynamoDB.lambda_function_name
  lambda_function_invoke_arn = module.lambda_dynamoDB.lambda_function_invoke_arn
  tags                       = local.tags
}

module "alarm_lambda02" {
  source               = "../modules/alarm"
  base_name            = "lambda02-${local.base_name}"
  lambda_function_name = module.lambda_dynamoDB.lambda_function_name
  sns_arn              = module.sns_slack.sns_topic_arn
}

module "alarms_api_gateway" {
  source        = "../modules/api-gateway/alarm"
  base_name     = local.base_name
  resource_name = "message"
  api_name      = module.api_gateway.api_name
  stage_name    = "stage-${var.service_name}-${var.environment}"
  sns_arn       = module.sns_slack.sns_topic_arn
}

module "sns_slack" {
  source               = "../modules/sns"
  base_name            = "slack-${local.base_name}"
  lambda_function_arn  = module.lambda_slack.lambda_function_arn
  lambda_function_name = module.lambda_slack.lambda_function_name
}
