module "network" {
  source  = "./modules/network"
  
  vpc     = var.vpc
  subnets = var.subnets
}
  
module "controllers" {
  source = "./modules/controllers"

  region  = var.region
  cluster = var.cluster
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
}

module "workers" {
  source = "./modules/workers"

  cluster_name = module.controllers.cluster_name
  private_subnet_ids  = module.network.private_subnet_ids
}
