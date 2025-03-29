provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"
}

module "eks_cluster" {
  source             = "../../modules/eks-cluster"
  subnet_ids         = module.vpc.public_subnet_ids
}

