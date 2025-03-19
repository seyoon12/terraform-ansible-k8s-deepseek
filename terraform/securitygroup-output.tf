output "bastion_sg_group_id" {
  description = "security group ID"
  value       = module.bastion_sg.security_group_id
}

output "bastion_sg_group_name" {
  description = "security group Name"
  value       = module.bastion_sg.security_group_name
}
