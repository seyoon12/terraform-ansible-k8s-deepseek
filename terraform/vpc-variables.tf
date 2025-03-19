variable "vpc_name" {
  description = "VPC Name"
  type = string 
  default = "vpc_main"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string 
  default = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2b"]
}

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type = list(string)
  default = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "availability_zone-2a" {
  type    = string
  default = "ap-northeast-2a"
}

variable "availability_zone-2b" {
  type    = string
  default = "ap-northeast-2b"
}
