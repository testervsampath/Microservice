variable "aws_region" {
  description = "The AWS region where resources will be created"
  default     = "ap-south-1" # Set your default AWS region here
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  default     = "t2.micro" # Set your default instance type here
}

variable "key_pair_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  default     = "MySecondKeyPair" # Set your default key pair name here
}

variable "ami_id" {
  description = "Ubuntu Ami"
  default     = "ami-03f4878755434977f" # Set your default ami here
}