variable "name" {}

variable "container_definitions" {}

variable "task_role_arn" {
  default = ""
}

variable "cloudwatch_log_group" {}

variable "volumes" {
  type    = "list"
  default = []
}
