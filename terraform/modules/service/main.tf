module "task" {
  source                = "../task"
  name                  = "${var.stack}-${var.environment}-${var.name}"
  task_role_arn         = "${module.task-role.arn}"
  container_definitions = "${var.container_definitions}"
  cloudwatch_log_group  = "${var.cloudwatch_log_group}"
  volumes               = "${var.volumes}"
}

module "task-role" {
  source  = "../role"
  name    = "${var.stack}-${var.environment}-${var.name}"
  service = "ecs-tasks"
}

resource "aws_iam_role_policy" "task-role-policy" {
  name   = "${var.stack}-${var.environment}-${var.name}-task-role"
  role   = "${module.task-role.id}"
  policy = "${data.aws_iam_policy_document.task-role-policy.json}"
}

data "aws_iam_policy_document" "task-role-policy" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["${module.secrets-manager.arn}"]
  }
}

module "secrets-manager" "main" {
  source = "../secrets-manager"
  name   = "${var.stack}-${var.environment}-${var.name}"
}

resource "aws_ecs_service" "main" {
  name            = "${var.stack}-${var.environment}-${var.name}"
  cluster         = "${var.cluster_name}"
  task_definition = "${module.task.family}:${max("${module.task.terraform_task_revision}", "${module.task.aws_task_revision}")}"
  iam_role        = "${var.iam_role}"
  desired_count   = "${var.desired_count}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target.arn}"
    container_name   = "${var.alb_check_container_name}"
    container_port   = "${var.container_port}"
  }

  ordered_placement_strategy = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "spread"
      field = "instanceId"
    }
  ]
}

module "service-autoscaling" {
  source               = "../service-autoscaling"
  service_name         = "${var.stack}-${var.environment}-${var.name}"
  cluster_name         = "${var.cluster_name}"
  autoscaling_role_arn = "${var.autoscaling_role_arn}"
  min_count            = "${var.min_count}"
  max_count            = "${var.max_count}"
}

resource "aws_alb_target_group" "alb_target" {
  name                 = "${var.environment_short}-${var.name}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.alb_vpc_id}"
  deregistration_delay = "${var.alb_deregistration_delay}"

  health_check {
    healthy_threshold   = "${var.alb_healthcheck_healthy_threshold}"
    unhealthy_threshold = "${var.alb_healthcheck_unhealthy_threshold}"
    timeout             = "${var.alb_healthcheck_timeout}"
    interval            = "${var.alb_healthcheck_interval}"
    path                = "${var.alb_healthcheck_path}"
    matcher             = "${var.alb_healthcheck_status_code}"
  }

  tags = {
    Name = "${var.stack}-${var.environment}-${var.name}"
  }
}

resource "aws_alb_listener_rule" "route_path" {
  listener_arn = "${var.alb_listener_arn}"
  priority     = "${var.alb_priority}"

  condition {
    field  = "host-header"
    values = ["${var.service_hostname}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.service_path_pattern}"]
  }

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target.arn}"
  }

  lifecycle {
    ignore_changes = ["priority"]
  }
}

resource "aws_route53_record" "external" {
  count   = "${var.service_hostname_zone_id != "" ? 1 : 0}"
  zone_id = "${var.service_hostname_zone_id}"
  name    = "${var.service_hostname}"
  type    = "A"

  alias {
    zone_id                = "${var.alb_zone_id}"
    name                   = "${var.alb_dns_name}"
    evaluate_target_health = false
  }
}
