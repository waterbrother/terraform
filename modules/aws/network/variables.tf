variable "vpc_cidr" {}

variable "subnets" {
  type        = list(map(string))
}

