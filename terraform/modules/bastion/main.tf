module "settings" {
  source = "../settings"
}

resource "aws_instance" "bastion" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion-server.id}"]

  tags = {
    Name        = "${var.name}-bastion"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "bastion-server" {
  name_prefix = "${var.stack}-${var.environment}-${var.name}-bast-srv-sg-"
  description = "Managed by terraform"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${module.settings.dev_ips}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.stack}-${var.environment}-${var.name}-bast-srv-sg"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "bastion-client" {
  name_prefix = "${var.stack}-${var.environment}-${var.name}-bast-cl-sg-"
  description = "Managed by terraform"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion-server.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.stack}-${var.environment}-${var.name}-bast-cl-sg"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}
