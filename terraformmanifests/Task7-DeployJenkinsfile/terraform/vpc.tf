data "aws_availability_zones" "azs" {}
module "vpc" {
  source                  = "../../Task7-JenkinCiCd/modules/vpc"
  tags                    = "myvpc"
  instance_tenancy        = "default"
  vpc_cidr                = "10.0.0.0/16"
  access_ip               = "0.0.0.0/0"
  public_sn_count         = 2
  availability_zone       = ["ap-south-1a", "ap-south-1b"]
  public_cidrs            = ["10.0.1.0/24", "10.0.2.0/24"]
  map_public_ip_on_launch = true
  rt_route_cidr_block     = "0.0.0.0/0"
}
