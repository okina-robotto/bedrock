output "id" {
  value = "${aws_rds_cluster.main.id}"
}

output "writer_endpoint" {
  value = "${aws_rds_cluster.main.endpoint}"
}

output "reader_endpoint" {
  value = "${aws_rds_cluster.main.reader_endpoint}"
}

output "port" {
  value = "${aws_rds_cluster.main.port}"
}
