output "k8s_public_key" {
    value     = aws_key_pair.k8s.public_key
    sensitive = true
}

output "k8s_private_key_pem" {
  value     = tls_private_key.tls_private_key.private_key_pem
  sensitive = true
}