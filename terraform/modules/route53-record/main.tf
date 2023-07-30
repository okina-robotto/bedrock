resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.name
  type    = var.type

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}
