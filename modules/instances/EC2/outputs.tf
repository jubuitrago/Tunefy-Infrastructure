output "nginx_instances" {
  value = aws_instance.nginx
}

output "backend_instances" {
  value = aws_instance.backend
}