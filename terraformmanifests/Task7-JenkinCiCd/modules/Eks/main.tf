# main.tf

// Eks cluster 
resource "aws_eks_cluster" "ekscluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eksnoderole.arn

  vpc_config {
    subnet_ids = var.aws_public_subnet
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.ekscluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ekscluster-AmazonEKSVPCResourceController,
  ]
}

// Eks cluster role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

// Assigning the Cluster Role to Eks Cluster
resource "aws_iam_role" "eksnoderole" {
  name               = "eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ekscluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksnoderole.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "ekscluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eksnoderole.name
}

// Eks node group
resource "aws_eks_node_group" "eksnodegroup" {
  cluster_name    = aws_eks_cluster.ekscluster.name
  node_group_name = "eksnodegrp"
  node_role_arn   = aws_iam_role.eksnodegrouprole.arn
  subnet_ids      = var.aws_public_subnet

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eksnodegroup-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eksnodegroup-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksnodegroup-AmazonEKSWorkerNodePolicy,
  ]
}

//Eks Node group Iam role
resource "aws_iam_role" "eksnodegrouprole" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

//Assigning Eks Node group Iam role to Eks node group
resource "aws_iam_role_policy_attachment" "eksnodegroup-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksnodegrouprole.name
}

resource "aws_iam_role_policy_attachment" "eksnodegroup-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksnodegrouprole.name
}

resource "aws_iam_role_policy_attachment" "eksnodegroup-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksnodegrouprole.name
}

//Security Group
resource "aws_security_group" "ekssecuritygroup" {
  name_prefix =  "ekssecuritygroup"
  vpc_id = var.vpc_id


   ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





