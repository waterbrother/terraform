variable "cluster" {
  type = map(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "kubeconfig_name" {
  type = string
  default = "kubeconfig.yaml"
}
