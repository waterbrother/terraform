resource "aws_vpc" "my_vpc" {
  cidr_block            = var.vpc.cidr_block
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_classic_link   = false
  enable_classic_link_dns_support = false
  assign_generated_ipv6_cidr_block  = false
  tags ={
    name = var.vpc.name
  }
}

output "vpc_id" {
  value             = aws_vpc.my_vpc.id
  sensitive         = false
}

resource "aws_subnet" "my_subnet" {
  count       			= length(var.subnets)
  vpc_id      			= aws_vpc.my_vpc.id
  availability_zone = var.subnets[count.index].az
  cidr_block        = var.subnets[count.index].cidr
  tags = {
  }
}

resource "aws_internet_gateway" "my_igw" {
	vpc_id 						= aws_vpc.my_vpc.id
}

resource "aws_eip" "my_eip" {
  count       			= length(var.subnets)
	vpc 							= true
}

resource "aws_nat_gateway" "my_nat_gw" {
  count       			= length(var.subnets)
	allocation_id 		= aws_eip.my_eip[count.index].id
	subnet_id 				= aws_subnet.my_subnet[count.index].id
}

resource "aws_route_table" "my_rt" {
	vpc_id 						= aws_vpc.my_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.my_igw.id
	}
}

resource "aws_route_table_association" "my_rt_assoc" {
  count       			= length(var.subnets)
	subnet_id 				= aws_subnet.my_subnet[count.index].id
	route_table_id 		= aws_route_table.my_rt.id
}
