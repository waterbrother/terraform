resource "aws_vpc" "test-vpc" {
  cidr_block  = "192.168.0.1/24"
}

resource "aws_subnet" "workers_az-a" {
  vpc_id            = ""
  availability_zone = ""
  cidr_block        = ""
  tags = {
  }
}

resource "aws_subnet" "workers_az-b" {
  vpc_id            = ""
  availability_zone = ""
  cidr_block        = ""
  tags = {
  }
}

resource "aws_subnet" "workers_az-b" {
  vpc_id            = ""
  availability_zone = ""
  cidr_block        = ""
  tags = {
  }
}

module "cluster" {
  source            = "../../modules"
}
