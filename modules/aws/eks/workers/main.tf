resource "aws_iam_role" "worker_nodes" {
  name    = "${var.cluster.name}-workers"
  assume_role_policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role        = aws_iam_role.worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role        = aws_iam_role.worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_policy" {
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role        = aws_iam_role.worker_nodes.name
}

resource "aws_eks_node_group" "worker_nodes" {
  cluster_name          = var.cluster.name
  node_group_name       = "${var.cluster.name}-workers"
  node_role_arn         = aws_iam_role.worker_nodes.arn

  subnet_ids            = var.private_subnet_ids

  scaling_config {
    desired_size  = var.scale.desired_size
    max_size      = var.scale.max_size
    min_size      = var.scale.min_size
  }

  # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type              = var.node.ami

  # ON_DEMAND, SPOT
  capacity_type         = var.node.capacity

  disk_size             = var.node.disk
  force_update_version  = false
  instance_types        = [ var.node.size ]

  labels = {
    role = "workers"
  }

  version = var.cluster.version

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_policy,
  ]
}
