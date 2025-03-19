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
  host                   = "https://<your-cluster-endpoint>"
  cluster_ca_certificate = base64decode("<your-ca-certificate>")
  token                  = "<your-kube-token>"
}

resource "kubernetes_manifest" "nginx_deployment" {
  manifest = yamldecode(file("nginx_deployment.yaml"))
}

resource "kubernetes_manifest" "nginx_service" {
  manifest = yamldecode(file("nginx_service.yaml"))
}

