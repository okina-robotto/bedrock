output "ecs_arn" {
  value = "${aws_cloudwatch_log_group.ecs.arn}"
}
