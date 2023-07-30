variable "cluster_name" {
  description = "The name of the ECS cluster where the service is running"
}

variable "service_name" {
  description = "The name of the ECS service"
}

variable "autoscaling_role_arn" {
  description = "The ARN of the ECS autoscaling role"
}

variable "min_count" {
  description = "The minimum number of tasks to run within the service"
}

variable "max_count" {
  description = "The maximum number of tasks to run within the service"
}

variable "scale_up_cpu_threshold" {
  description = "The average CPU percentage threshold when a task is added"
  default     = 60
}

variable "scale_down_cpu_threshold" {
  description = "The average CPU percentage threshold when a task is removed"
  default     = 20
}

variable "scale_up_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scale in activity completes before another scale in activity can start"
  default     = 60
}

variable "scale_down_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scale out activity completes before another scale out activity can start"
  default     = 120
}

variable "scale_up_scaling_adjustment" {
  description = "The scaling adjustment for the scale up event"
  default     = 2
}

variable "scale_down_scaling_adjustment" {
  description = "The scaling adjustment for the scale down event"
  default     = -1
}
