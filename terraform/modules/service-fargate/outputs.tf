output "alb_listener_id" {
  value = aws_alb_listener.main.id
}

output "alb_target_group_id" {
  value = aws_alb_target_group.main.id
}

output "alb_zone_id" {
  value = module.alb.zone_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}
