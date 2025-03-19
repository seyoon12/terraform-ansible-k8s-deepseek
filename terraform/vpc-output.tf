output "vpc_id" {
  description = "vpc_id"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "public subnets"
  value       = aws_subnet.public_subnet
}

output "private_subnets" {
  description = "private subnets"
  value       = aws_subnet.private_subnet
}

output "public_subnet_2a" {
  description = "Public subnet ID in ap-northeast-2a"
  value       = data.aws_subnet.public_subnet_2a.id
}

output "public_subnet_2b" {
  description = "Public subnet ID in ap-northeast-2b"
  value       = data.aws_subnet.public_subnet_2b.id
}
