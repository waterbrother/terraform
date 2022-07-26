# IAM role, policy, & attachment
resource "aws_iam_role" "eks_cluster" {
  name                = var.cluster.name
  assume_role_policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  # AWS Managed Policy
  # https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1&skipRegion=true#/policies/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy$jsonEditor
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role        = aws_iam_role.eks_cluster.name
}


# EKS cluster
resource "aws_eks_cluster" "eks" {
  name                = var.cluster.name
  role_arn            = aws_iam_role.eks_cluster.arn
  #version             = var.cluster.version

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}

output "cluster_name" {
  value = aws_eks_cluster.eks.id
}

# write kubeconfig to local disk
resource "local_file" "kubeconfig" {
  filename    = var.kubeconfig_name
  content     = local.kubeconfig_content
}

