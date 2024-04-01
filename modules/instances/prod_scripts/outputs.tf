output "bastion_provision_script" {
  value = local_file.bastion_provision_script.content
}

output "chef_nodes_provision_scripts" {
  value = local_file.chef_nodes_provision_scripts
}