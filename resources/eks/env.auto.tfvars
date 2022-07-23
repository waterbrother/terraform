region = "us-east-2"
vpc = {
  cidr = "10.0.0.0/16"
  name = "julianrutledge.com"
}

subnets = {
  public = [
    {
      az = "us-east-2a"
      cidr = "10.0.0.0/24"
    },
    {
      az = "us-east-2b"
      cidr = "10.0.1.0/24"
    }
  ]
  private = [
    {
      az = "us-east-2a"
      cidr = "10.0.2.0/24"
    },
    {
      az = "us-east-2b"
      cidr = "10.0.3.0/24"
    }
  ]
}

cluster = {
  name = "eks_cluster"
  version  = "1.22.10" # currently commented out in module to use default
}
