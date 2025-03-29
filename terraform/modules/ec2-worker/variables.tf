variable "user_data" {
  type        = string
}
variable "ami" {
  type        = string
}

variable "instance_type" {
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

variable "security_group_ids" {
  type = list(string)
}