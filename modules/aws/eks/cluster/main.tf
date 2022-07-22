module "network" {
  source  = "../network"
  
  vpc     = var.vpc
  subnets = var.subnets
}
  
