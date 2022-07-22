variable "cluster" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "scale" {
  type = map(number)
  default = {
    desired_size  = 1,
    max_size      = 1,
    min_size      = 1,
  }
}

variable "node" {
  type = map(string)
  default = {
    ami       = "AL2_x86_64",
    capacity  = "ON_DEMAND",
    disk      = "20G",
    size      = "t3.small",
  }
}

