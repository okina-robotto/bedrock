variable "name" {}
variable "stack" {}
variable "environment" {}
variable "environment_short" {}
variable "cluster_name" {}
variable "iam_role" {}
variable "min_count" {}
variable "desired_count" {}
variable "max_count" {}
variable "container_port" {
  default = 80
}
variable "container_definitions" {}
variable "cloudwatch_log_group" {}
variable "volumes" {
  type    = "list"
  default = []
}

variable "alb_deregistration_delay" {
  default = 10
}
variable deployment_minimum_healthy_percent {
  default = 100
}

variable deployment_maximum_percent {
  default = 200
}

variable "volume_names" {
  type    = "list"
  default = []
}

variable "volume_host_paths" {
  type    = "list"
  default = []
}

variable "autoscaling_role_arn" {}

variable "alb_check_container_name" {}
variable "alb_vpc_id" {}
variable "alb_priority" {}
variable "alb_listener_arn" {}
variable "alb_zone_id" {}
variable "alb_dns_name" {}
variable "alb_healthcheck_path" {}
variable "alb_healthcheck_status_code" {
  default = "200"
}

variable "alb_healthcheck_healthy_threshold" {
  default = 5
}

variable "alb_healthcheck_unhealthy_threshold" {
  default = 2
}

variable "alb_healthcheck_timeout" {
  default = 20
}

variable "alb_healthcheck_interval" {
  default = 30
}

variable "service_hostname" {}

variable "service_path_pattern" {}

variable "service_hostname_zone_id" {
  default = ""
}
