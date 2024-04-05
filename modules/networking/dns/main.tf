resource "aws_route53_record" "endavabogota" {
  zone_id = "Z1TYT3MHQZ6P44"
  name    = "tunefy.endavabogota.com"
  type    = "A"
  alias {
    name                   = var.internet_facing_load_balancer_url
    zone_id                = var.internet_facing_load_balancer_zone_id
    evaluate_target_health = false
  }
}