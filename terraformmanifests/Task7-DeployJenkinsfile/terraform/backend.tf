terraform {
  backend "s3" {
         bucket = "my-kube-test-bucket-1"
          region = "ap-south-1"
          key  = "eks/terraform.tfstate"
  }
}

