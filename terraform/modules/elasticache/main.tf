resource "aws_elasticache_replication_group" "main" {
  replication_group_description = "Redis"
  automatic_failover_enabled    = true
  availability_zones            = var.availability_zones
  replication_group_id          = var.replication_group_id
  node_type                     = var.instance_type
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.main.name
  security_group_ids            = ["${aws_security_group.main.id}"]
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = false

  tags = {
    Name        = var.name
    Stack       = var.stack
    Environment = var.environment
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.stack}-${var.environment}-${var.name}-ec-ng"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "main" {
  name_prefix = "${var.stack}-${var.environment}-${var.name}-ec-sg-"
  description = "Permit access to an Elasticache Cluster"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.security_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.stack}-${var.environment}-${var.name}-ec-sg"
    Stack       = var.stack
    Environment = var.environment
  }
}
