output "task_role_id" {
  value = "${module.task-role.id}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.alb_target.arn}"
}

output "endpoint" {
  value = "${var.service_hostname}"
}
