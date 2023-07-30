output "name" {
  value = "${aws_ecs_task_definition.main.family}"
}

output "arn" {
  value = "${aws_ecs_task_definition.main.arn}"
}

output "family" {
  value = "${aws_ecs_task_definition.main.family}"
}

output "aws_task_revision" {
  value = "${data.aws_ecs_task_definition.main.revision}"
}

output "terraform_task_revision" {
  value = "${aws_ecs_task_definition.main.revision}"
}
