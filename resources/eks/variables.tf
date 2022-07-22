variable "region" {
  default     = "us-east-2"
}

variable "vpc" {
  type        = map(string)
}

variable "subnets" {
  type        = map(list(map(string)))
}

