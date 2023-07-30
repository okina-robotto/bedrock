variable "name" {}
variable "stack" {}
variable "environment" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = "list"
}
variable "security_group_ids" { 
  type = "list"
}
variable "port" {}
variable "app_port" {}
variable "interval" {
  default = 30
}
variable "healthcheck_path" {
  default = "/"
}
variable "certificate_arn" {}
variable "log_bucket_name" {}
