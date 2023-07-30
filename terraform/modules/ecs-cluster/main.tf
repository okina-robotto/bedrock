resource "aws_ecs_cluster" "main" {
  name = "${var.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "main" {
  count                = "${1 - var.use_spot}"
  name_prefix          = "${var.name}-"
  instance_type        = "${var.instance_type}"
  image_id             = "${var.instance_ami}"
  security_groups      = ["${var.security_group_ids}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.name}"
  key_name             = "${var.key_name}"
  user_data            = "${data.template_cloudinit_config.config.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}"
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = "${var.docker_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  count                = "${1 - var.use_spot}"
  name                 = "${var.name}"
  availability_zones   = ["${var.availability_zones}"]
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.main.id}"
  desired_capacity     = "${var.auto_scaling_desired_capacity}"
  min_size             = "${var.auto_scaling_min_size}"
  max_size             = "${var.auto_scaling_max_size}"
  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "${var.name}-ecs-cluster-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.ecs-init.rendered}"
  }

  part {
    content_type = "text/cloud-boothook"
    content      = "${var.custom_cloudinit_config}"
  }
}

data "template_file" "ecs-init" {
  template = "${file("${path.module}/templates/init.sh.tpl")}"

  vars {
    cluster = "${var.name}"
  }
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.name}-ecs-instance-profile"
  path = "/"
  role = "${aws_iam_role.ecs_role.name}"
}

resource "aws_iam_role" "ecs_role" {
  name = "${var.name}-ecs-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.name}-ecs-service-role-policy"
  role   = "${aws_iam_role.ecs_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_service_role_policy.json}"
}

data "aws_iam_policy_document" "ecs_service_role_policy" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "${var.name}-ecs-instance-role-policy"
  role   = "${aws_iam_role.ecs_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_instance_role_policy.json}"
}

data "aws_iam_policy_document" "ecs_instance_role_policy" {
  statement {
    actions = [
      "autoscaling:*",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DiscoverPollEndpoint",
      "ecs:ListServices",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:RegisterTaskDefinition",
      "ecs:StartTask",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:UpdateService",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets",
      "iam:PassRole",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }
}
