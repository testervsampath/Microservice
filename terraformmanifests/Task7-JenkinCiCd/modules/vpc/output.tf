output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "aws_public_subnet" {
  description = "The IDs of the subnets"
  value       = aws_subnet.my_subnets.*.id
}