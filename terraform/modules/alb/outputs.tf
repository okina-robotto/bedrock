output "name" {
  value = "${aws_alb.main.name}"
}

output "id" {
  value = "${aws_alb.main.id}"
}

output "arn" {
  value = "${aws_alb.main.arn}"
}

output "dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "zone_id" {
  value = "${aws_alb.main.zone_id}"
}

output "load_balancer_client_security_group_id" {
  value = "${aws_security_group.load_balancer_client.id}"
}
