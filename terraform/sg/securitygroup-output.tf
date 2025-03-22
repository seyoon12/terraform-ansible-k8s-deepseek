output "masternode_sg_group_id" {
  value = module.masternode_sg.security_group_id
}

output "masternode_sg_group_name" {
  value = module.masternode_sg.security_group_name
}

output "workernodes_sg_group_name" {
  value = module.workernodes_sg.security_group_name
}

output "workernodes_sg_group_ids" {
  value = module.workernodes_sg.security_group_id
}
output "bastion_sg_group_id" {
  value = module.bastion_sg.security_group_id
}

output "bastion_sg_group_name" {
  value = module.bastion_sg.security_group_name
}