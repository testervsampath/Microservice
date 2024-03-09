terraform {
  backend "s3" {
         bucket = "my-tf-test-bucket"
          region = "ap-south-1"
          key  = "eks/terraform.tfstate"
  }
}

