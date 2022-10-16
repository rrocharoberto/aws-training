locals {
  base_name          = "aws-training-${random_integer.base_number.id}"
  lambda_source_file = "${path.module}/../app/lambda01/target/lambda01-0.1.jar"
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

module "lambda" {
    source = "./modules/lambda"
  base_name          = local.base_name
  lambda_source_file = local.lambda_source_file
  aws_region         = var.aws_region
  lab_role_arn       = var.lab_role_arn
 }
