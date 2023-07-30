variable "name" {
  description = "The name of the VPC"
}

variable "stack" {
  description = "The name of the Stack for the VPC"
}

variable "environment" {
  description = "The name of the Environment for the VPC"
}

variable "cidr" {
  description = "The CIDR block to use for the VPC"
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = "list"
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = "list"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = "list"
}

variable "bastion_ami" {
  default = "ami-f0a06892" // ap-southeast-2 Amazon Linux AMI 2018.03 (HVM)
}

variable "key_name" {
  description = "SSH key for the NAT and the bastion"
}
