variable "name" {
  description = "The name of the bastion"
}

variable "stack" {
  description = "The name of the Stack for the bastion"
}

variable "environment" {
  description = "The name of the Environment for the bastion"
}

variable "instance_type" {
  default     = "t2.nano"
  description = "Instance type"
}

variable "ami" {
  description = "AMI to use for the instance"
}

variable "vpc_id" {
  description = "VPC for the bastion"
}

variable "subnet_id" {
  description = "Subnet id (public)"
}

variable "key_name" {
  description = "The SSH key for the instance"
}
