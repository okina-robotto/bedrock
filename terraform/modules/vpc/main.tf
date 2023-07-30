module "settings" {
  source = "../settings"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.*.id[0]}"
  depends_on    = ["aws_internet_gateway.main"]
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${var.name}"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count             = "${length(var.private_subnets)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags = {
    Name        = "${var.name}-private-subnet"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.public_subnets, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "${var.name}-public-subnet"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main.id}"
  }

  tags = {
    Name        = "${var.name}-private-route-table"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table" "public" {
  count  = "${length(var.public_subnets)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name        = "${var.name}-public-route-table"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_default_security_group" "default" {
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.stack}-${var.environment}-${var.name}-default-sg"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "web" {
  name_prefix  = "${var.stack}-${var.environment}-${var.name}-web-sg-"
  vpc_id       = "${aws_vpc.main.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name        = "${var.stack}-${var.environment}-${var.name}-web-sg"
    Stack       = "${var.stack}"
    Environment = "${var.environment}"
  }
}

module "bastion" {
  source      = "../bastion"
  name        = "${var.name}"
  stack       = "${var.stack}"
  environment = "${var.environment}"
  vpc_id      = "${aws_vpc.main.id}"
  ami         = "${var.bastion_ami}"
  subnet_id   = "${aws_subnet.public.*.id[0]}"
  key_name    = "${var.key_name}"
}

resource "aws_eip" "bastion" {
  instance = "${module.bastion.public_ip}"
  vpc      = true
}

resource "aws_iam_role" "main" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "main" {
  name_prefix = "/vpc/${var.stack}-${var.environment}-${var.name}-"
}

resource "aws_flow_log" "main" {
  iam_role_arn    = "${aws_iam_role.main.arn}"
  log_destination = "${aws_cloudwatch_log_group.main.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.main.id}"
}

resource "aws_iam_role_policy" "main" {
  role = "${aws_iam_role.main.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
