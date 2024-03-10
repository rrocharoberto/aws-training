
##### S3 Bucket resources #####
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "bucket-${var.base_name}"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  count  = var.lab_role_arn == "" ? 1 : 0
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}
