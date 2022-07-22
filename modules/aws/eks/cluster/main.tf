module "network" {
  source  = "../network"
  
  vpc     = var.vpc
  subnets = var.subnets
}
  
module "controllers" {
  source = "../controllers"

  cluster = var.cluster
  public_subnet_ips   = module.network.public_subnet_ips
  private_subnet_ips  = module.network.private_subnet_ips
}

module "workers" {
  source = "../workers"

  cluster = var.cluster
  private_subnet_ips  = module.network.private_subnet_ips
}
