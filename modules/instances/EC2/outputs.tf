output "nginx_instances_id_list" {
  value = [for instance in aws_instance.nginx : instance.id]
}

output "backend_instances_id_list" {
  value = [for instance in aws_instance.backend : instance.id]
}