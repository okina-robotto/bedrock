data "aws_caller_identity" "current" {}
resource "aws_s3_bucket" "main" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true

  logging {
    target_bucket = var.log_bucket_name
    target_prefix = "${var.stack}-${var.environment}-${var.name}/AWSLogs/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/${var.stack}-${var.environment}-${var.name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role" "main" {
  name_prefix        = "cloudtrail_events_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

resource "aws_iam_role_policy" "main" {
  name_prefix = "cloudtrail_cloudwatch_events_policy"
  role        = "${aws_iam_role.main.id}"
  policy      = "${data.aws_iam_policy_document.main.json}"
}

data "aws_iam_policy_document" "main" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.default.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.default.name}:log-stream:*",
    ]
  }
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "default" {
  name = "/cloudtrail/${var.stack}-${var.environment}-${var.name}"
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.stack}-${var.environment}-${var.name}"
  s3_bucket_name                = aws_s3_bucket.main.id
  s3_key_prefix                 = "${var.stack}-${var.environment}-${var.name}"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.main.arn
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.default.arn
  kms_key_id                    = var.kms_key_id

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  tags = {
    Name        = var.name
    Stack       = var.stack
    Environment = var.environment
  }
}
