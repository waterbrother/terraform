module "network" {
  source  = "../network"
  
  vpc     = var.vpc
  subnets = var.subnets
}
  
module "controllers" {
  source = "../controllers"

  cluster = var.cluster
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
}

module "workers" {
  source = "../workers"

  cluster = var.cluster
  private_subnet_ids  = module.network.private_subnet_ids
}
