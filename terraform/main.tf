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

provider "kubernetes" {
  host                   = 
  cluster_ca_certificate = 
  token                  = 
}

