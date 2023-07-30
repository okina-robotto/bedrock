output "public_ip" {
  value = "${aws_instance.bastion.id}"
}

output "bastion_client_security_group_id" {
  value = "${aws_security_group.bastion-client.id}"
}

output "bastion_server_security_group_id" {
  value = "${aws_security_group.bastion-server.id}"
}
