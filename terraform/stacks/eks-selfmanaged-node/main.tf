data "terraform_remote_state" "eks_cluster" {
  backend = "local"

  config = {
    path = "../eks-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.selected.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.selected.token
}

module "keypair" {
  source = "../../modules/keyPair"
}

module "sg" {
  source = "../../modules/sg"
  vpc_id = data.terraform_remote_state.eks_cluster.outputs.vpc_id
}

data "aws_eks_cluster" "selected" {
  name = "kubernetes"
}

data "aws_eks_cluster_auth" "selected" {
  name = "kubernetes"
}

module "eks_self_managed_node_group" {
  source = "../../modules/eks-selfmanaged-node"
  key_name               = module.keypair.k8s_keyname
  security_group_ids     = [module.sg.eks-selfmanaged-node_sg_group_ids]
  eks_cluster_endpoint   = data.aws_eks_cluster.selected.endpoint
  eks_cluster_ca         = data.aws_eks_cluster.selected.certificate_authority[0].data
  eks_cluster_token      = data.aws_eks_cluster_auth.selected.token
  subnets                = data.terraform_remote_state.eks_cluster.outputs.public_subnet_ids
  eks_cluster_name       = "kubernetes"
  instance_type          = "t3.medium"
  desired_capacity       = 1
  min_size               = 1
  max_size               = 1

  node_labels = {
    "node.kubernetes.io/node-group" = "test-node"
  }
}