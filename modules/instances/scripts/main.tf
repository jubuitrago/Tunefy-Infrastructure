resource "local_file" "bastion_provision_script" {
  filename = "${path.module}/provision_scripts/bastion_provision_script.sh"
  content = templatefile("${path.module}/templates/bastion_provision_script_template.sh", {
    CHEF_SERVER_VERSION = "14.11.21"
  })
}

resource "local_file" "bastion_chef_setup" {
  filename = "${path.module}/setup_scripts/bastion_chef_setup.sh"
  content = templatefile("${path.module}/templates/bastion_chef_setup_template.sh", {
    NGINX_1_IP            = var.nginx_instances_ip_list[0]
    NGINX_2_IP            = var.nginx_instances_ip_list[1]
    FRONTEND_1_IP         = var.frontend_instances_ip_list[0]
    FRONTEND_2_IP         = var.frontend_instances_ip_list[1]
    BACKEND_1_IP          = var.backend_instances_ip_list[0]
    BACKEND_2_IP          = var.backend_instances_ip_list[1]
    PRIMARY_DATABASE_IP   = var.primary_database_instances_ip_list[0]
    REPLICA_DATABASE_IP   = var.replica_database_instances_ip_list[0]
    CICD_IP               = var.cicd_instances_ip_list[0]
    K8S_MASTER_1_IP       = var.k8s_master_instances_ip_list[0]
    K8S_MASTER_2_IP       = var.k8s_master_instances_ip_list[1]
  })
}

resource "local_file" "chef_nodes_provision_scripts" {
  count = length(var.chef_nodes_names_list)

  filename = "${path.module}/provision_scripts/${var.chef_nodes_names_list[count.index]}_provision_script.sh"
  content = templatefile("${path.module}/templates/chef_nodes_provision_script_template.sh", {
    BASTION_IP = var.bastion_instance_ip_list[0]
    NODE_NAME  = var.chef_nodes_names_list[count.index]
  })
}