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
  desired_count   = "${var.desired_count}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"

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
