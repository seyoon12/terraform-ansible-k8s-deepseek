module "eks-cluster_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    name = "eks-cluster__sg"
    vpc_id = var.vpc_id
    ingress_rules = ["all-all"]
    ingress_cidr_blocks = ["0.0.0.0/0"]
    egress_rules = ["all-all"]
}
