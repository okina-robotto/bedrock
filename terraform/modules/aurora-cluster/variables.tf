variable "name" {
  description = "Name of the cluster"
}

variable "stack" {
  description = "Stack the cluster belongs to"
}

variable "environment" {
  description = "Environment the cluster belongs to"
}

variable "vpc_id" {}

variable "security_groups" {
  type    = "list"
  default = []
}

variable "security_cidr_blocks" {
  type    = "list"
  default = []
}

variable "subnet_ids" {
  type = "list"
}

variable "username" {
  default = "root"
}

variable "password" {}

variable "storage_encrypted" {
  default = true
}

variable "parameter_group_name" {
  default = ""
}

variable "engine" {
  default = "aurora-postgresql" // postgresql 9.6.*
}

variable "instance_type" {}

variable "port" {
  default = 5432
}

variable "publicly_accessible" {
  default = false
}

variable "backup_retention_period" {
  default = 14
}

variable "backup_window" {
  default = "17:00-17:30"
}

variable "maintenance_window" {
  default = "mon:18:00-mon:18:30"
}

variable "is_multi_az" {
  default = false
}

variable "initial_snapshot_identifier" {
  default = ""
}

variable "kms_key_arn" {
  default = ""
}

variable "replication_source_region" {
  default = ""
}

variable "replication_source_arn" {
  default = ""
}
