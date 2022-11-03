locals {
  base_name  = "aws-training-${random_integer.base_number.id}"
  queue_name = "aws-training-queue"

  lambda01_source_file = "${path.module}/../app/lambda01/target/lambda01-0.1.jar"
  lambda02_source_file = "${path.module}/../app/lambda02/target/lambda02-0.1.jar"
  lambda03_source_file = "${path.module}/../app/lambda03/target/lambda03-0.1.jar"
  lambda04_source_file = "${path.module}/../app/lambda04/target/lambda04-0.1.jar"
  lambda05_source_file = "${path.module}/../app/lambda05/target/lambda05-0.1.jar"

  lambda01_class_name = "com.roberto.aws.lambda.FunctionHello"
  lambda02_class_name = "com.roberto.aws.lambda.FunctionSQSConsumer"
  lambda03_class_name = "com.roberto.aws.lambda.FunctionSQSProducer"
  lambda04_class_name = "com.roberto.aws.lambda.FunctionDLQConsumer"
  lambda05_class_name = "com.roberto.aws.lambda.FunctionDynamoEvent"
}

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
}

resource "random_integer" "base_number" {
  min = 1000
  max = 9999
}

module "lambda_hello" {
  source             = "./modules/lambda"
  base_name          = "01-${local.base_name}"
  lambda_source_file = local.lambda01_source_file
  lambda_class_name  = local.lambda01_class_name
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "lambda_sqs" {
  source             = "./modules/lambda"
  base_name          = "02-${local.base_name}"
  lambda_source_file = local.lambda02_source_file
  lambda_class_name  = local.lambda02_class_name
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "lambda_event_generator" {
  source             = "./modules/lambda"
  base_name          = "03-${local.base_name}"
  lambda_source_file = local.lambda03_source_file
  lambda_class_name  = local.lambda03_class_name
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "lambda_dlq" {
  source             = "./modules/lambda"
  base_name          = "04-${local.base_name}"
  lambda_source_file = local.lambda04_source_file
  lambda_class_name  = local.lambda04_class_name
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "lambda_dynamoDB_stream" {
  source             = "./modules/lambda"
  base_name          = "05-${local.base_name}"
  lambda_source_file = local.lambda05_source_file
  lambda_class_name  = local.lambda05_class_name
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "sqs" {
  source                 = "./modules/sqs"
  base_name              = local.queue_name
  destination_lambda_arn = module.lambda_sqs.lambda_function_arn
  dead_letter_queue_arn  = module.dlq.dead_letter_queue_arn
  lab_role_arn           = var.lab_role_arn
}

module "dlq" {
  source                 = "./modules/sqs/dlq"
  base_name              = local.base_name
  destination_lambda_arn = module.lambda_dlq.lambda_function_arn
  lab_role_arn           = var.lab_role_arn
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  base_name    = local.base_name
  lab_role_arn = var.lab_role_arn
}

# module "api-gateway" {
#   source               = "./modules/api-gateway"
#   base_name            = local.base_name
#   lambda_function_name = module.lambda_hello.lambda_function_name
#   lambda_function_arn  = module.lambda_hello.lambda_function_arn
#   lab_role_arn         = var.lab_role_arn
# }
