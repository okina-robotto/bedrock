output "id" {
  value = "${aws_vpc.main.id}"
}

output "arn" {
  value = "${aws_vpc.main.arn}"
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "availability_zones" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}

output "nat_eip" {
  value = "${aws_eip.nat.public_ip}"
}

output "bastion_public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

output "default_security_group_id" {
  value = "${aws_vpc.main.default_security_group_id}"
}

output "bastion_client_security_group_id" {
  value = "${module.bastion.bastion_client_security_group_id}"
}

output "bastion_server_security_group_id" {
  value = "${module.bastion.bastion_server_security_group_id}"
}

output "web_security_group_id" {
  value = "${aws_security_group.web.id}"
}
