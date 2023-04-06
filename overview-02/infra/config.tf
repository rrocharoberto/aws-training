terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 0.12.26"
}

provider "aws" {
  region = var.aws_region
}

resource "random_integer" "base_number" {
  min = 1000
  max = 9999
}
