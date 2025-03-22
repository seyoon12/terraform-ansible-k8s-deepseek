terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
    profile = "default" # $HOME/.aws/credentials 에 있는 계정 정보를 사용하여 로그인
    region  = var.aws_region # default = ap-northeast-2
}

module "vpc" {
  source = "./vpc-module"
}

module "keypair" {
  source = "./keyPair-module"
}

module "sg" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
}

module "master_node" {
  source            = "./ec2-master-module"
  subnet_id         = module.vpc.public_subnet_id   
  availability_zone = module.vpc.availability_zone_0
  key_name          = module.keypair.k8s_keyname
  masternode_sg_group_id = [module.sg.masternode_sg_group_id]
  user_data             = file("${path.module}/scripts/master-userdata.sh")
  ami               = var.ami
  instance_type     = var.instance_type
}

module "worker_node_01" {
  source            = "./ec2-worker-module/"
  subnet_id         = module.vpc.public_subnet_id
  availability_zone = module.vpc.availability_zone_0
  key_name          = module.keypair.k8s_keyname
  workernodes_sg_group_ids = [module.sg.workernodes_sg_group_ids]
  user_data             = file("${path.module}/scripts/worker-userdata.sh")
  ami               = var.ami
  instance_type     = var.instance_type
}

module "worker_node_02" {
  source            = "./ec2-worker-module/"
  subnet_id         = module.vpc.public_subnet_id
  availability_zone = module.vpc.availability_zone_0
  key_name          = module.keypair.k8s_keyname
  workernodes_sg_group_ids = [module.sg.workernodes_sg_group_ids]
user_data             = file("${path.module}/scripts/worker-userdata.sh")
  ami               = var.ami
  instance_type     = var.instance_type
}