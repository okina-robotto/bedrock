resource "aws_sqs_queue" "main" {
  name                       = "${var.name}"
  visibility_timeout_seconds = "${var.visibility_timeout}"
  message_retention_seconds  = "${var.message_retention}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time}"
  redrive_policy             = "${data.template_file.redrive-policy.rendered}"
}

data "template_file" "redrive-policy" {
  template = "${file("${path.module}/redrive_policy.json")}"

  vars = {
    max_receive_count = "${var.max_receive_count}"
    target_arn        = "${aws_sqs_queue.dead-letter.arn}"
  }
}

resource "aws_sqs_queue" "dead-letter" {
  name                       = "${var.name}-dead-letter"
  visibility_timeout_seconds = "${var.dead_letter_queue_visibility_timeout}"
  message_retention_seconds  = "${var.message_retention}"
  max_message_size           = "${var.max_message_size}"
  delay_seconds              = "${var.delay_seconds}"
  receive_wait_time_seconds  = "${var.receive_wait_time}"
}
