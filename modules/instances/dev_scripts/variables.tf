variable "bastion_instance_ip_list" {}

variable "nginx_instances_ip_list" {}

variable "frontend_instances_ip_list" {}

variable "backend_instances_ip_list" {}

variable "primary_database_instances_ip_list" {}

variable "replica_database_instances_ip_list" {}

variable "cicd_instances_ip_list" {}

variable "k8s_master_instances_ip_list" {}

variable "chef_nodes_names_list" {
  default = ["nginx1", "nginx2", "frontend1", "frontend2", "backend1", "backend2", "primarydatabase", "replicadatabase", "cicd", "k8smaster1", "k8smaster2"]
}