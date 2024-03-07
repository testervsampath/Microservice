
//Creating VPC resource
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.instance_tenancy
  tags = {
    Name = var.tags
  }
}

//Creating Internet gateway

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags ={
    Name = var.tags
  }
}

// Data from Aws for Avaliability zones
data "aws_availability_zones" "available" {}


// Adding available zones to input
resource "random_shuffle" "az-list" {
  input = data.aws_availability_zones.available.names
  result_count = 2
}

// Creating AWS Subnets
resource "aws_subnet" "my_subnets" {
   count = var.public_sn_count
   vpc_id = aws_vpc.my_vpc.id  
   cidr_block = var.public_cidrs[count.index]
   availability_zone =  element(var.availability_zone, count.index)
   map_public_ip_on_launch = var.map_public_ip_on_launch

    tags ={
    Name = var.tags
  }
}

// Creating Route table
resource "aws_default_route_table" "internal_default" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route { 
    cidr_block = var.rt_route_cidr_block
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
  tags = {
    Name = var.tags
  }
}

// Creating Route table Association
resource "aws_route_table_association" "default" {
  count = var.public_sn_count
  subnet_id = aws_subnet.my_subnets[count.index].id
  route_table_id = aws_default_route_table.internal_default.id

}



