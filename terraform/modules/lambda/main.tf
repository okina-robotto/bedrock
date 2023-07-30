resource "aws_iam_policy" "main" {
  policy = "${data.aws_iam_policy_document.main.json}"
}

data "aws_iam_policy_document" "main" {
  statement {
    actions   = var.actions
    resources = var.resources
  }
}

resource "aws_iam_role" "main" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = "${aws_iam_role.main.name}"
  policy_arn = "${aws_iam_policy.main.arn}"
}

resource "aws_lambda_function" "main" {
  filename         = var.filename
  function_name    = var.function_name
  role             = aws_iam_role.main.arn
  handler          = var.handler

  source_code_hash = "${filebase64sha256("${var.filename}")}"
  runtime          = var.runtime

  depends_on       = ["aws_iam_role_policy_attachment.main"]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = {
    Name        = var.name
    Stack       = var.stack
    Environment = var.environment
  }
}
