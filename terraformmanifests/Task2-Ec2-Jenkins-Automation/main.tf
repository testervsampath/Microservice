# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
# jenkins instance resources
resource "aws_instance" "ec2-jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  #userdata script for installing jenkins
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y #update the repository
    sudo apt install openjdk-11-jdk -y #install the jdk 11
    sudo apt install git -y //install git
    wget https://get.jenkins.io/war-stable/2.440.1/jenkins.war
    java -jar jenkins.war //start Jenkins
    EOF
  tags = {
    Name = "jenkins-manual-automation"
  }
}
#ip adress for jenkins instance
output "jenkins_public_ip" {
  value = aws_instance.ec2-jenkins.public_ip
}