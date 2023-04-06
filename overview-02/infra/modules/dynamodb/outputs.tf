# Output value definitions
output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.table_message.arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.table_message.id
}

output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when var.stream_enabled is true"
  value       = aws_dynamodb_table.table_message.stream_arn
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = aws_dynamodb_table.table_message.stream_label
}