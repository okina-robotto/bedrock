resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.name}"
  retention_in_days = 30

  tags = {
    Name = "${var.name}-lg"
  }
}

resource "aws_cloudwatch_log_stream" "ecs" {
  name           = "${var.name}-ls"
  log_group_name = aws_cloudwatch_log_group.ecs.name
}
