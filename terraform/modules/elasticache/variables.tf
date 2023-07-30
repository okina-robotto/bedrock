variable "vpc_id" {
  description = "The Stack VPC ID"
}

variable "stack" {
  description = "The name of the Stack for the VPC"
}

variable "environment" {
  description = "The name of the Environment for the VPC"
}

variable "cluster_id" {
  description = "Cluster"
}

variable "name" {}

variable "replication_group_id" {
  description = "Replication Group"
}

variable "instance_type" {
  description = "Iinstance type"
}

variable "availability_zones" {
  description = "List of AZs"
  type        = "list"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
}

variable "security_cidr_blocks" {}
