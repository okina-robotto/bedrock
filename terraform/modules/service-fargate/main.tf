module "alb" {
  source             = "../alb"
  stack              = var.stack
  environment        = var.environment
  name               = "${var.stack}-${var.environment}-${var.name}"
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  log_bucket_name    = var.log_bucket_name
}

resource "aws_alb_target_group" "main" {
  name        = "${var.stack}-${var.environment}-${var.name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = var.interval
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.healthcheck_path
    unhealthy_threshold = "10"
  }
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = module.alb.id
  port              = var.port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }

  #default_action {
  #  type = "redirect"
  #
  #  redirect {
  #    port        = "443"
  #    protocol    = "HTTPS"
  #    status_code = "HTTP_301"
  #  }
  #}
}

resource "aws_alb_listener" "main_ssl" {
  load_balancer_arn = module.alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}
