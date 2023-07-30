data "aws_ecs_task_definition" "main" {
  task_definition = "${aws_ecs_task_definition.main.family}"
  depends_on      = ["aws_ecs_task_definition.main"]
}

resource "aws_ecs_task_definition" "main" {
  family        = "${var.name}"
  task_role_arn = "${var.task_role_arn}"

  lifecycle {
    create_before_destroy = true
  }

  container_definitions = "${var.container_definitions}"

  volume = ["${var.volumes}"]
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.cloudwatch_log_group}"
  retention_in_days = 14
}
