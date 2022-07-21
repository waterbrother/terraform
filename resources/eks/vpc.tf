provider "aws" {
  region = var.region
}

resource "aws_vpc" "eks" {
  cidr_block  = "192.168.0.0/24"
}

