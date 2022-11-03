locals {
  name = "ddb-table-${var.base_name}"
  tags = {
    Environment = "Test"
    Owner       = "Roberto Rocha"
    Creator     = "Terraform"
    Resource    = local.name
  }
}

resource "aws_dynamodb_table" "table_example" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "messageId"
  #range_key        = var.range_key
  #  read_capacity    = 20
  #  write_capacity   = 20
  #stream_enabled   = var.stream_enabled
  #stream_view_type = var.stream_view_type
  table_class = "STANDARD"

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

  tags = merge(local.tags, { Type = "dynamo"
  })
}
