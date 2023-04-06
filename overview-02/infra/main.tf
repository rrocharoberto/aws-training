locals {
  base_name  = "${var.environment}-${var.service_name}-${random_integer.base_number.id}"
  queue_name = "queue-${local.base_name}"

  lambda01_source_file = "${path.module}/../app/lambda01/target/lambda01-0.1.jar"
  lambda02_source_file = "${path.module}/../app/lambda02/target/lambda02-0.1.jar"
  lambda03_source_file = "${path.module}/../app/lambda03/target/lambda03-0.1.jar"
  lambda04_source_file = "${path.module}/../app/lambda04/target/lambda04-0.1.jar"
  lambda05_source_file = "${path.module}/../app/lambda05/target/lambda05-0.1.jar"

  lambda01_jar = "lambda-01.jar"
  lambda02_jar = "lambda-02.jar"
  lambda03_jar = "lambda-03.jar"
  lambda04_jar = "lambda-04.jar"
  lambda05_jar = "lambda-05.jar"

  lambda01_handler = "com.roberto.aws.lambda.FunctionHello"
  lambda02_handler = "com.roberto.aws.lambda.FunctionSQSConsumer"
  lambda03_handler = "com.roberto.aws.lambda.FunctionSQSProducer"
  lambda04_handler = "com.roberto.aws.lambda.FunctionDLQConsumer"
  lambda05_handler = "com.roberto.aws.lambda.FunctionDynamoEvent"

  message_table_name = "${var.environment}-message-table"

  tags = {
    Environment = var.environment
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
  }
}

module "s3_bucket_lambdas" {
  source    = "./modules/s3"
  base_name = local.base_name
  tags      = local.tags
}

module "lambda_hello" {
  source    = "./modules/lambda"
  base_name = "01-${local.base_name}"
  runtime   = "java11"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = local.lambda01_source_file
  lambda_handler     = local.lambda01_handler
  s3_object_name     = local.lambda01_jar

  tags = local.tags
}

module "lambda_sqs_consumer" {
  source    = "./modules/lambda"
  base_name = "02-${local.base_name}"
  runtime   = "java11"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = local.lambda02_source_file
  lambda_handler     = local.lambda02_handler
  s3_object_name     = local.lambda02_jar

  tags = local.tags
}

module "lambda_sqs_producer" {
  source    = "./modules/lambda"
  base_name = "03-${local.base_name}"
  runtime   = "java11"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = local.lambda03_source_file
  lambda_handler     = local.lambda03_handler
  s3_object_name     = local.lambda03_jar

  tags = local.tags
}

module "lambda_dlq" {
  source    = "./modules/lambda"
  base_name = "04-${local.base_name}"
  runtime   = "java11"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = local.lambda04_source_file
  lambda_handler     = local.lambda04_handler
  s3_object_name     = local.lambda04_jar

  tags = local.tags

  env_vars = {
    MESSAGE_DYNAMODB_TABLE_NAME = local.message_table_name
  }
}

module "lambda_dynamoDB_stream" {
  source    = "./modules/lambda"
  base_name = "05-${local.base_name}"
  runtime   = "java11"

  service_name = var.service_name
  environment  = var.environment

  lambda_bucket_id   = module.s3_bucket_lambdas.s3_bucket_id
  lambda_source_file = local.lambda05_source_file
  lambda_handler     = local.lambda05_handler
  s3_object_name     = local.lambda05_jar

  tags = local.tags
}

module "sqs" {
  source                 = "./modules/sqs"
  base_name              = local.queue_name
  destination_lambda_arn = module.lambda_sqs_consumer.lambda_function_arn
  dead_letter_queue_arn  = module.dlq.dead_letter_queue_arn
  lambda_role_id         = module.lambda_sqs_consumer.lambda_role_id
}

module "dlq" {
  source                 = "./modules/sqs/dlq"
  base_name              = local.base_name
  destination_lambda_arn = module.lambda_dlq.lambda_function_arn
  lambda_role_id         = module.lambda_dlq.lambda_role_id
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = local.message_table_name
}

module "lambda_dynamo_config" {
  source           = "./modules/lambda/dynamo-op-policy"
  base_name        = "04-${local.base_name}"
  lambda_role_id   = module.lambda_dlq.lambda_role_id
  dynamo_table_arn = module.dynamodb.dynamodb_table_arn
  tags             = local.tags
}

module "lambda_dynamo_stream_attachment" {
  source                  = "./modules/lambda/dynamo-stream-policy"
  base_name               = "05-${local.base_name}"
  lambda_role_id          = module.lambda_dynamoDB_stream.lambda_role_id
  dynamo_table_arn        = module.dynamodb.dynamodb_table_arn
  dynamo_table_stream_arn = module.dynamodb.dynamodb_table_stream_arn
  destination_lambda_arn  = module.lambda_dynamoDB_stream.lambda_function_arn
  tags                    = local.tags
}

module "alarm_lambda02" {
  source               = "./modules/alarm"
  base_name            = "lambda02-${local.base_name}"
  lambda_function_name = module.lambda_sqs_consumer.lambda_function_name
  sns_arn              = module.sns-email.sns_email_arn
}

module "sns-email" {
  source          = "./modules/sns"
  base_name       = "email-${local.base_name}"
  email_recipient = var.email_recipient
}
