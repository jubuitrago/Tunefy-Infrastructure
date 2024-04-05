output "internet_facing_load_balancer_exists" {
  value = length(aws_lb.internet_facing) > 0
}

output "internet_facing_load_balancer_url" {
  value = aws_lb.internet_facing.dns_name
}

output "internet_facing_load_balancer_zone_id" {
  value = aws_lb.internet_facing.zone_id
}

output "backend_load_balancer_url" {
  value = aws_lb.backend.dns_name
}