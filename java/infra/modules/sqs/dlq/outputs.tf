# Output value definitions

output "dead_letter_queue_arn" {
  description = "ARN of the dead letter queue."
  value       = aws_sqs_queue.dead_letter_queue.arn
}
