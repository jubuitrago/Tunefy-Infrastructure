variable "tunefy_bastion_SG_id" {}

variable "tunefy_nginx_SG_id" {}

variable "tunefy_frontend_SG_id" {}

variable "tunefy_backend_SG_id" {}

variable "tunefy_primary_database_SG_id" {}

variable "tunefy_replica_database_SG_id" {}

variable "tunefy_k8s_master_SG_id" {}

variable "tunefy_cicd_SG_id" {}

variable "subnet_ids_list_map" {}

variable "bastion_provision_script" {}

variable "chef_nodes_provision_scripts" {}

variable "dev_env" {}