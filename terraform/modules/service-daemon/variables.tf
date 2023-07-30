variable "name" {}
variable "stack" {}
variable "environment" {}
variable "cluster_name" {}
variable "min_count" {}
variable "desired_count" {}
variable "max_count" {}
variable "container_definitions" {}
variable "cloudwatch_log_group" {}
variable "volumes" {
  type    = "list"
  default = []
}

variable deployment_minimum_healthy_percent {
  default = 100
}

variable deployment_maximum_percent {
  default = 200
}

variable "autoscaling_role_arn" {}
