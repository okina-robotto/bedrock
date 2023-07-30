resource "aws_secretsmanager_secret" "main" {
  name = "${var.name}"
}

resource "aws_secretsmanager_secret_version" "init" {
  secret_id     = "${aws_secretsmanager_secret.main.id}"
  secret_string = "${jsonencode(map("empty", "value"))}"

  lifecycle {
    ignore_changes = ["secret_string"]
  }
}
