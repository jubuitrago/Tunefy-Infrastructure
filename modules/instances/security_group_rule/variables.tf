variable "internet_facing_load_balancer_exists" {}

variable "tunefy_bastion_SG_id" {}  

variable "tunefy_nginx_SG_id" {}

variable "tunefy_frontend_SG_id" {}

variable "tunefy_backend_SG_id" {}

variable "tunefy_primary_database_SG_id" {}

variable "tunefy_replica_database_SG_id" {}

variable "tunefy_k8s_master_SG_id" {}

variable "tunefy_cicd_SG_id" {}

variable "tunefy_internet_facing_ALB_SG_id" {}

variable "bastion_instance_ip_list" {}

variable "nginx_instances_ip_list" {}

variable "replica_database_instances_ip_list" {}
     
variable "SG_ids_list" {}

variable "chef_nodes_ip_list" {}

variable "k8s_nodes_ip_list" {}

variable "k8s_master_ip_list" {}