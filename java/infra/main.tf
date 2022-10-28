locals {
  base_name            = "aws-training-${random_integer.base_number.id}"
  lambda01_source_file = "${path.module}/../app/lambda01/target/lambda01-0.1.jar"
  lambda02_source_file = "${path.module}/../app/lambda02/target/lambda02-0.1.jar"
  lambda03_source_file = "${path.module}/../app/lambda03/target/lambda03-0.1.jar"
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
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Roberto Rocha"
      Build       = local.base_name
      Creator     = "Terraform"
    }
  }
}

resource "random_integer" "base_number" {
  min = 1000
  max = 9999
}

module "lambda_hello" {
  source             = "./modules/lambda"
  base_name          = "01-${local.base_name}"
  lambda_source_file = local.lambda01_source_file
  lambda_class_name  = "com.roberto.aws.lambda.FunctionHello"
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "lambda_sqs" {
  source             = "./modules/lambda"
  base_name          = "02-${local.base_name}"
  lambda_source_file = local.lambda02_source_file
  lambda_class_name  = "com.roberto.aws.lambda.FunctionSQS"
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "sqs" {
  source                 = "./modules/sqs"
  base_name              = local.base_name
  destination_lambda_arn = module.lambda_sqs.lambda_function_arn
  lab_role_arn           = var.lab_role_arn
}

module "lambda_dlq_source" {
  source             = "./modules/lambda"
  base_name          = "03-${local.base_name}"
  lambda_source_file = local.lambda03_source_file
  lambda_class_name  = "com.roberto.aws.lambda.FunctionSQS"
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
}

module "dlq" {
  source         = "./modules/sqs/dlq"
  base_name      = local.base_name
  dlq_lambda_arn = module.lambda_sqs.lambda_function_arn
  lab_role_arn   = var.lab_role_arn
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
