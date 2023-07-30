output "name" {
  value = "${aws_ecs_cluster.main.name}"
}
output "arn" {
  value = "${aws_ecs_cluster.main.id}"
}
output "ecs_role_arn" {
  value = "${aws_iam_role.ecs_role.arn}"
}

output "ecs_instance_profile_arn" {
  value = "${aws_iam_instance_profile.ecs_instance_profile.arn}"
}

output "ecs_instance_profile_name" {
  value = "${aws_iam_instance_profile.ecs_instance_profile.name}"
}
