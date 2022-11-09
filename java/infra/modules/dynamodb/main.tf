locals {
  name = "${var.base_name}-message"
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
  #range_key        = "messageCategory"

  #read_capacity    = 20
  #write_capacity   = 20
  stream_enabled   = true
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

  tags = merge(local.tags, { Type = "dynamo" })
}

resource "aws_lambda_event_source_mapping" "lambda_dynamo_mapping" {
  event_source_arn       = aws_dynamodb_table.table_example.stream_arn
  function_name          = var.destination_lambda_arn
  starting_position      = "LATEST"
  batch_size             = 1
  maximum_retry_attempts = 2
}
