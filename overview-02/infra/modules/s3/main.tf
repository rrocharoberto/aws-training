locals {
  name = "bucket-${var.base_name}"
  tags = {
    Environment = "Test"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
    Resource    = local.name
  }
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = local.name
  tags   = merge(local.tags, { Type = "Bucket" })
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}
