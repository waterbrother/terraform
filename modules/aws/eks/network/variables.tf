variable "vpc" {
  type = map(string)
}

variable "subnets" {
  type = map(list(map(string)))
}

