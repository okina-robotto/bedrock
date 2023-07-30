resource "aws_rds_cluster" "main" {
  cluster_identifier              = "${var.stack}-${var.environment}-aurora-cluster"
  engine                          = "${var.engine}"
  master_username                 = "${var.username}"
  master_password                 = "${var.password}"
  port                            = "${var.port}"
  storage_encrypted               = "${var.storage_encrypted}"
  backup_retention_period         = "${var.backup_retention_period}"
  preferred_backup_window         = "${var.backup_window}"
  preferred_maintenance_window    = "${var.maintenance_window}"
  final_snapshot_identifier       = "${var.stack}-${var.environment}-aurora-cluster-final-snapshot"
  db_subnet_group_name            = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids          = ["${aws_security_group.main.id}"]
  snapshot_identifier             = "${var.initial_snapshot_identifier}"
  kms_key_id                      = "${var.kms_key_arn}"
  source_region                   = "${var.replication_source_region}"
  replication_source_identifier   = "${var.replication_source_arn}"

  tags = {
    Name        = "${var.name} - Cluster"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["master_password"]
  }
}

resource "aws_rds_cluster_instance" "main" {
  count                   = "${var.is_multi_az ? 2 : 1}"
  identifier_prefix       = "${var.stack}-${var.environment}-aurora-"
  cluster_identifier      = "${aws_rds_cluster.main.id}"
  instance_class          = "${var.instance_type}"
  engine                  = "${var.engine}"
  db_parameter_group_name = "${var.parameter_group_name}"
  db_subnet_group_name    = "${aws_db_subnet_group.main.name}"

  tags = {
    Name        = "${var.stack}-${var.environment}-aurora-cluster-instance"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "${var.name}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = {
    Name        = "${var.stack}-${var.environment}-aurora-cluster-subnet-group"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "main" {
  name_prefix = "${var.stack}-${var.environment}-aurora-cluster-server-"
  description = "Managed by terraform"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
    cidr_blocks     = ["${var.security_cidr_blocks}"]
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
    Name        = "${var.stack}-${var.environment}-aurora-cluster-server"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}
