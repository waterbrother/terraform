variable "region" {
  default     = "us-east-2"
}

variable "vpc_cidr" {}

variable "subnets" {
  type        = list(map(string))
}
