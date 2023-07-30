resource "aws_appautoscaling_target" "main" {
  service_namespace  = "ecs"
  role_arn           = "${var.autoscaling_role_arn}"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = "${var.min_count}"
  max_capacity       = "${var.max_count}"
}

resource "aws_appautoscaling_policy" "up" {
  name               = "${var.cluster_name}-scale-up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.scale_up_cooldown_seconds}"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = "${var.scale_up_scaling_adjustment}"
    }
  }

  depends_on = [
    "aws_appautoscaling_target.main",
  ]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "${var.cluster_name}-scale-down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.scale_down_cooldown_seconds}"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = "${var.scale_down_scaling_adjustment}"
    }
  }

  depends_on = [
    "aws_appautoscaling_target.main",
  ]
}

resource "aws_cloudwatch_metric_alarm" "app_service_high_cpu" {
  alarm_name          = "${var.cluster_name}-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.scale_up_cpu_threshold}"

  dimensions = {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${var.service_name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "app_service_low_cpu" {
  alarm_name          = "${var.cluster_name}-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.scale_down_cpu_threshold}"

  dimensions = {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${var.service_name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.down.arn}"]
}
