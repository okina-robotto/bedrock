output "arn" {
  value = aws_ecs_task_definition.fargate.arn
}

output "security_group_id" {
  value = aws_security_group.main.id
}
