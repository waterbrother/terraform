module "cluster" {
  source  = "../../modules/aws/eks/cluster"

  vpc     = var.vpc
  subnets = var.subnets
  cluster = var.cluster
}

