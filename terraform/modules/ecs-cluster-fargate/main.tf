resource "aws_ecs_cluster" "main" {
  name = "${var.stack}-${var.environment}-${var.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.stack}-${var.environment}-${var.name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = var.task_definition
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = var.subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_id
    container_name   = "${var.stack}-${var.environment}-${var.name}"
    container_port   = var.app_port
  }

  depends_on = [var.alb_listener_id, var.role_policy_attachment_id]

  tags = {
    Name        = var.name
    Stack       = var.stack
    Environment = var.environment
  }
}
