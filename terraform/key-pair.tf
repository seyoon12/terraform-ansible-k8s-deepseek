resource "tls_private_key" "tls_private_key" {
    algorithm = "RSA"
    rsa_bits = "2048"
}

resource "aws_key_pair" "k8s" {
    key_name = "k8s"
    public_key = tls_private_key.tls_private_key.public_key_openssh
}

resource "tls_private_key" "logsvr_key" {
    algorithm = "RSA"
    rsa_bits = "2048"
}

resource "aws_key_pair" "logsvr_key" {
    key_name = "logsvr_key"
    public_key = tls_private_key.logsvr_key.public_key_openssh
}


