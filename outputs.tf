/*
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.worker[count.index].id
}
*/

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = [aws_instance.worker.*.public_ip]
}

output "sqs_in" {
  description = "URL of the SQS incomming queue"
  value       = aws_sqs_queue.in_queue.arn
  #value = data.aws_sqs_queue.in_queue.url
}

output "sqs_out" {
  description = "URL of the SQS outgoing queue"
  value       = aws_sqs_queue.out_queue.arn
}
