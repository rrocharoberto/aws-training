locals {
  name = "${var.base_name}-message"
}

resource "aws_dynamodb_table" "table_example" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "messageId"
  #range_key        = "messageCategory"

  #read_capacity    = 20
  #write_capacity   = 20
  stream_enabled   = false
  stream_view_type = "NEW_AND_OLD_IMAGES"
  table_class      = "STANDARD"

  attribute {
    name = "messageId"
    type = "S"
  }

  ttl {
    enabled        = true
    attribute_name = "expirationTime"
  }

  server_side_encryption {
    enabled = true
  }

  #  lifecycle {ignore_changes = [write_capacity, read_capacity]}

  tags = var.tags
}
