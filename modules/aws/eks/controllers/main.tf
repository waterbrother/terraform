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
        "Service": "eks.amazon.com"
      },
    "Action": "sts.AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  # AWS Managed Policy
  # https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEKSClusterPolicy
  policy_arn  = "arn:aws:iam::aws:policy:AmazonEKSClusterPolicy"
  role        = aws_iam_role.eks_cluster.name
}


# EKS cluster
resource "aws_eks_cluster" "eks" {
  name                = var.cluster.name
  role_arn            = aws_iam_role.eks_cluster.arn
  version             = var.cluster.version

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}
