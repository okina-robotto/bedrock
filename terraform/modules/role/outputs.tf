output "arn" {
  value = "${aws_iam_role.main.arn}"
}

output "name" {
  value = "${aws_iam_role.main.name}"
}

output "id" {
  value = "${aws_iam_role.main.id}"
}

output "role_policy_attachment_id" {
  value = "${aws_iam_role_policy_attachment.main.id}"
}
