variable "name" {
  description = "Name of the queue"
}

variable "visibility_timeout" {
  description = "Main queue visibility timeout (in seconds)"
}

variable "message_retention" {
  description = "Message retention (in seconds) for both queues"
  default     = 1209600
}

variable "max_message_size" {
  description = "Max message size (in bytes) for both queues"
  default     = 262144
}

variable "delay_seconds" {
  description = "Message delay (in seconds) for both queues"
  default     = 0
}

variable "receive_wait_time" {
  description = "Message receive wait time (in seconds) for both queues"
  default     = 0
}

variable "max_receive_count" {
  description = "Number of times a message is delivered to the main queue before it's sent to the dead letter queue."
}

variable "dead_letter_queue_visibility_timeout" {
  description = "Dead letter queue visibility timeout (in seconds)"
}
