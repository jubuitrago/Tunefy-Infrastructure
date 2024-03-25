output "bastion_provision_script" {
  value = local_file.bastion_provision_script.content
}

output "nginx_provision_script" {
  value = local_file.nginx_provision_script.content
}