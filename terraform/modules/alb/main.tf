resource "aws_alb" "main" {
  name                       = var.name
  internal                   = false
  enable_deletion_protection = false
  subnets                    = var.subnet_ids
  security_groups            = var.security_group_ids

  access_logs {
    bucket  = var.log_bucket_name
    prefix  = "${var.name}"
    enabled = true
  }

  tags = {
    Name        = "${var.name}"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "load_balancer_client" {
  name_prefix = "${var.name}-alb-sg-"
  vpc_id      = "${var.vpc_id}"
  description = "Managed by terraform"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = var.security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.name}-alb-sg"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}
