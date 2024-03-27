variable "bastion_instance_ip_list" {}

variable "nginx_instances_ip_list" {}

variable "frontend_instances_ip_list" {}

variable "backend_instances_ip_list" {}

variable "primary_database_instances_ip_list" {}

variable "replica_database_instances_ip_list" {}

variable "cicd_instances_ip_list" {}

variable "k8s_master_instances_ip_list" {}

variable "chef_nodes_names_list" {
  default = ["nginx", "frontend", "backend", "primary_database", "replica_database", "cicd", "k8s_master"]
}