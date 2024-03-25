output "nginx_instances_id_list" {
  value = [for instance in aws_instance.nginx : instance.id]
}

output "backend_instances_id_list" {
  value = [for instance in aws_instance.backend : instance.id]
}

output "nginx_instances_ip_list" {
  value = [for instance in aws_instance.nginx : format("%s/32", instance.private_ip)]
}
