output "internet_facing_load_balancer_exists" {
  value = length(aws_lb.internet_facing) > 0
}

output "internet_facing_load_balancer_url" {
  value = aws_lb.internet_facing.dns_name
}

output "backend_load_balancer_url" {
  value = aws_lb.backend.dns_name
}