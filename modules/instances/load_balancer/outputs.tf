output "internet_facing_load_balancer_exists" {
  value = length(aws_lb.internet_facing) > 0
}