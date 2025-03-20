module "bastion_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    name    = "bastion_sg"
    vpc_id  = aws_vpc.main.id

    ingress_with_cidr_blocks = [
        { rule = "ssh-tcp", cidr_blocks = ["0.0.0.0/0"] },      # 22
        { rule = "http-80-tcp", cidr_blocks = ["0.0.0.0/0"] },  # 80
        { rule = "https-443-tcp", cidr_blocks = ["0.0.0.0/0"] } # 443
    ]
    egress_rules = ["all-all"]
}
