locals {
  base_name = "${var.environment}-${var.service_name}-${random_integer.base_number.id}"

  lambda03_source_file = "${path.module}/../../app/lambda-03/lambda_slack.py"
  lambda03_handler     = "lambda_slack.lambda_handler"
  lambda03_zip         = "lambda-03.zip"

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

module "alarm_billing" {
  source               = "../modules/alarm/billing"
  base_name            = "lambda02-${local.base_name}"
  sns_arn              = module.sns_slack.sns_topic_arn
}

module "sns_slack" {
  source               = "../modules/sns"
  base_name            = "slack-${local.base_name}"
  lambda_function_arn  = module.lambda_slack.lambda_function_arn
  lambda_function_name = module.lambda_slack.lambda_function_name
}
