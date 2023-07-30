output "name" {
  value = "${aws_sqs_queue.main.name}"
}

output "endpoint" {
  value = "${aws_sqs_queue.main.id}"
}

output "arn" {
  value = "${aws_sqs_queue.main.arn}"
}
