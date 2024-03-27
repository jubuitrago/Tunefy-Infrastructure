output "nginx_instances_id_list" {
  value = [for instance in aws_instance.nginx : instance.id]
}

output "backend_instances_id_list" {
  value = [for instance in aws_instance.backend : instance.id]
}


output "bastion_instance_ip_list" {
  value = [for instance in aws_instance.bastion : instance.private_ip]
}

output "nginx_instances_ip_list" {
  value = [for instance in aws_instance.nginx : instance.private_ip]
}

output "frontend_instances_ip_list" {
  value = [for instance in aws_instance.frontend : instance.private_ip]
}

output "backend_instances_ip_list" {
  value = [for instance in aws_instance.backend : instance.private_ip]
}

output "primary_database_instances_ip_list" {
  value = [for instance in aws_instance.primary_database : instance.private_ip]
}

output "replica_database_instances_ip_list" {
  value = [for instance in aws_instance.replica_database : instance.private_ip]
}

output "cicd_instances_ip_list" {
  value = [for instance in aws_instance.cicd : instance.private_ip]
}

output "k8s_master_instances_ip_list" {
  value = [for instance in aws_instance.k8s_master : instance.private_ip]
}

output "chef_nodes_ip_list" {
  value = concat(
    [for instance in aws_instance.nginx : instance.private_ip],
    [for instance in aws_instance.frontend : instance.private_ip],
    [for instance in aws_instance.backend : instance.private_ip],
    [for instance in aws_instance.primary_database : instance.private_ip],
    [for instance in aws_instance.replica_database : instance.private_ip],
    [for instance in aws_instance.cicd : instance.private_ip],
    [for instance in aws_instance.k8s_master : instance.private_ip]
  )
}

output "k8s_nodes_ip_list" {
  value = concat(
    [for instance in aws_instance.frontend : instance.private_ip],
    [for instance in aws_instance.backend : instance.private_ip]
  )
}