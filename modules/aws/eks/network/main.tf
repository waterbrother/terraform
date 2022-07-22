resource "aws_vpc" "main" {
  cidr_block            = var.vpc.cidr

  # eks configs
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_classiclink   = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block  = false

  tags ={
    name = var.vpc.name
  }
}

resource "aws_internet_gateway" "main" {
	vpc_id 						= aws_vpc.main.id

  tags = {
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
    name = "${var.vpc.name}-public-${count.index}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "private" {
  count       			= length(var.subnets.private)
  vpc_id      			= aws_vpc.main.id
  availability_zone = var.subnets.private[count.index].az
  cidr_block        = var.subnets.private[count.index].cidr

  tags = {
    name = "${var.vpc.name}-private-${count.index}"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# EIP and Nat GW for internet access from private subnets
resource "aws_eip" "main" {
  count       			= length(var.subnets.private)
	vpc 							= true
  depends_on        = [ aws_internet_gateway.main ]
}

resource "aws_nat_gateway" "main" {
  count       			= length(var.subnets.private)
	allocation_id 		= aws_eip.main[count.index].id
	subnet_id 				= aws_subnet.public[count.index].id
}

# route tables for default routes from subnets
resource "aws_route_table" "public" {
  count             = length(var.subnets.public)
	vpc_id 						= aws_vpc.main.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.main[count.index].id
	}

  tags = {
    name = "public"
  }
}

resource "aws_route_table_association" "public" {
  count       			= length(var.subnets.public)
	subnet_id 				= aws_subnet.public[count.index].id
	route_table_id 		= aws_route_table.public[count.index].id
}

resource "aws_route_table" "private" {
  count             = length(var.subnets.private)
	vpc_id 						= aws_vpc.main.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.main[count.index].id
	}

  tags = {
    name = "private"
  }
}

resource "aws_route_table_association" "private" {
  count       			= length(var.subnets.private)
	subnet_id 				= aws_subnet.private[count.index].id
	route_table_id 		= aws_route_table.private[count.index].id
}

