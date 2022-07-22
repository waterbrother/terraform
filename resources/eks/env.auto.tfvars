region = "us-east-2"
vpc = {
  cidr = "192.168.0.0/24"
  name = "julianrutledge.com"
}

subnets = {
  public = [
    {
      az = "us-east-2a"
      cidr = "196.168.0.0/27"
    },
    {
      az = "us-east-2b"
      cidr = "196.168.0.32/27"
    }
  ]
  private = [
    {
      az = "us-east-2a"
      cidr = "196.168.0.128/26"
    },
    {
      az = "us-east-2b"
      cidr = "196.168.0.192/26"
    }
  ]
}
