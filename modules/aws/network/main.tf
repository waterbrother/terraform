resource "aws_vpc" "main" {
  cidr_block            = var.vpc.cidr_block

  # eks configs
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_classic_link   = false
  enable_classic_link_dns_support   = false
  assign_generated_ipv6_cidr_block  = false

  tags ={
    name = var.vpc.name
  }
}

resource "aws_internet_gateway" "main" {
	vpc_id 						= aws_vpc.main.id

  tags ={
    name = var.vpc.name
  }
}

output "vpc_id" {
  value             = aws_vpc.main.id
  sensitive         = false
}

resource "aws_subnet" "public" {
  count       			= length(var.subnets.public)
  vpc_id      			= aws_vpc.main.id
  availability_zone = var.subnets.public[count.index].az
  cidr_block        = var.subnets.public[count.index].cidr

  # eks configs
  map_public_ip_on_launch = true

  tags = {
    name = "${var.vpc.name}-public-${count.index}
    kubernetes.io/cluster/eks = "shared"
    kubernetes.io/role/elb    = 1
  }
}

resource "aws_subnet" "private" {
  count       			= length(var.subnets.private)
  vpc_id      			= aws_vpc.main.id
  availability_zone = var.subnets.private[count.index].az
  cidr_block        = var.subnets.private[count.index].cidr

  tags = {
    name = "${var.vpc.name}-private-${count.index}
    kubernetes.io/cluster/eks       = "shared"
    kubernetes.io/role/internal-elb = 1
  }
}

resource "aws_eip" "my_eip" {
  count       			= length(var.subnets)
	vpc 							= true
}

resource "aws_nat_gateway" "my_nat_gw" {
  count       			= length(var.subnets)
	allocation_id 		= aws_eip.my_eip[count.index].id
	subnet_id 				= aws_subnet.public[count.index].id
}

resource "aws_route_table" "my_rt" {
	vpc_id 						= aws_vpc.main.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.main.id
	}
}

resource "aws_route_table_association" "my_rt_assoc" {
  count       			= length(var.subnets)
	subnet_id 				= aws_subnet.public[count.index].id
	route_table_id 		= aws_route_table.my_rt.id
}
