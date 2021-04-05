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
