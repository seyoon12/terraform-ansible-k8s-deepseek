variable "user_data" {
  type        = string
}
variable "ami" {
  description = "ubuntu-22.04"
  type        = string
  default     = "ami-024ea438ab0376a47"
}

variable "instance_type" {
  description = "t3.medium"
  default = "t3.medium"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "workernodes_sg_group_ids" {
  type = list(string)
}