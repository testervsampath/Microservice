# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu Server 22.04 LTS (HVM)*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#  }

resource "aws_instance" "myapp-server" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = "MySecondKeyPair"
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_default_security_group.default-sg.id] 
    availability_zone = var.avail_zone
    associate_public_ip_address = true
    user_data = file("jenkins-server-script.sh")
    tags = {
      Name = "${var.env_prefix}-server"
    }


  
}