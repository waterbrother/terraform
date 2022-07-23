module "cluster" {
  source  = "../../modules/aws/eks/cluster"

  region  = var.region
  vpc     = var.vpc
  subnets = var.subnets
  cluster = var.cluster
}

