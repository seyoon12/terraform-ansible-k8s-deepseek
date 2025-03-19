variable "instance_type_t3_medium" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.medium"  
}

variable "instance_type_t2_samll" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.small"  
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type = string
  default = "k8s"
}

variable "ami" {
    type = string
    default = "ami-024ea438ab0376a47" # ubuntu_22.04TLS
}

variable "instance_name_bastion" {
    type = string
    default = "bastion"
}