module "ecr" {
  source = "../ecr_repository"

  name = var.name
}

data "template_file" "fargate" {
  template = file("../../infrastructure/modules/task-fargate/templates/fargate.json.tpl")

  vars = {
    repo   = module.ecr.repository_url
    name   = var.name
    port   = var.app_port
    cpu    = var.cpu
    memory = var.memory
    region = var.region
  }
}

resource "aws_ecs_task_definition" "fargate" {
  family                   = "${var.name}-task"
  execution_role_arn       = var.role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = data.template_file.fargate.rendered
}

resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  description = "Allow access to the ALB."
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.port
    to_port     = var.port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.name
    Stack       = var.stack
    Environment = var.environment
  }
}
