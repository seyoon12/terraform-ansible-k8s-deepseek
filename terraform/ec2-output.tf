# output "ec2_bastion_public_instance_id" {
#   description = "EC2 instance ID"
#   value       = module.ec2_bastion.id
# }

# output "ec2_bastion_public_ip" {
#   description = "Public IP address EC2 instance"
#   value       = module.ec2_bastion.public_ip 
# }

output "ec2_masternode_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.master_node.id
}

output "ec2_masternode_ip" {
  description = "private IP address EC2 instance"
  value       = aws_instance.master_node.private_ip 
}

output "ec2_workernode_ip" {
  description = "private IP address EC2 instance"
  value       = aws_instance.worker_node.private_ip 
}