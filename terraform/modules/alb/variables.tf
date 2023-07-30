variable "name" {
  description = "The name of the ALB"
}
variable "stack" {
  description = "The name of the Stack for the ALB"
}
variable "environment" {
  description = "The name of the Environment for the ALB"
}
variable "vpc_id" {
  description = "The ID of the VPC for the security groups"
}
variable "subnet_ids" {
  type = "list"
}
variable "security_group_ids" {
  type = "list"
}
variable "log_bucket_name" {}
