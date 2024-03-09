# outputs.tf

output "instance_id" {
  description = "The ID of the launched instance"
  value       = aws_instance.myapp-server.id
}

output "public_ip" {
  description = "The public IP address of the launched instance"
  value       = aws_instance.myapp-server.public_ip
}

output "private_ip" {
  description = "The private IP address of the launched instance"
  value       = aws_instance.myapp-server.private_ip
}
