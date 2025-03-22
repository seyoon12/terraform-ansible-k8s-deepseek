output "availability_zone_0" {
  value = var.vpc_availability_zones[0]
}

output "availability_zone_1" {
  value = var.vpc_availability_zones[1]
}
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private_subnet.id
}

output "public_subnet_az" {
  description = "Availability Zone of Public Subnet"
  value       = aws_subnet.public_subnet.availability_zone
}

output "private_subnet_az" {
  description = "Availability Zone of Private Subnet"
  value       = aws_subnet.private_subnet.availability_zone
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "route_table_id" {
  description = "Route Table ID"
  value       = aws_route_table.route_table.id
}

output "route_id" {
  description = "Route to Internet Gateway"
  value       = aws_route.route_igw.id
}

output "public_subnet_association_id" {
  description = "Route Table Association ID for Public Subnet"
  value       = aws_route_table_association.route_table_association_1.id
}

output "private_subnet_association_id" {
  description = "Route Table Association ID for Private Subnet"
  value       = aws_route_table_association.route_table_association_2.id
}
