locals {
  prefix_name = "aws-training"
  base_name   = "${local.prefix_name}-${random_integer.base_number.id}"

  lambda_source_file = "${path.module}/../app/lambda-02/target/lambda-02-0.1.jar"
  lambda_class_name = "com.roberto.aws.lambda.MessageController"
  
  tags = {
    Environment = "Demo"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
  }
}

module "lambda_bucket" {
  source       = "./modules/s3"
  base_name    = "02-${local.base_name}"
  tags = local.tags
}

module "lambda_dynamoDB" {
  source             = "./modules/lambda"
  base_name          = "02-${local.base_name}"

  service_name = var.service_name
  environment = var.environment

  lambda_bucket_id   = module.lambda_bucket.s3_bucket_id
  lambda_source_file = local.lambda_source_file
  lambda_class_name  = local.lambda_class_name

  message_table_arn = module.dynamodb.dynamodb_table_arn
  tags = local.tags
}

module "dynamodb" {
  source                 = "./modules/dynamodb"
  base_name              = local.prefix_name
  tags = local.tags
}

module "api-gateway" {
   source               = "./modules/api-gateway"
   base_name            = local.base_name
   resource_url         = "/message"
   stage_name           = "stage-${var.service_name}-${var.environment}"

   lambda_function_name = module.lambda_dynamoDB.lambda_function_name
   lambda_function_arn  = module.lambda_dynamoDB.lambda_function_arn
 }