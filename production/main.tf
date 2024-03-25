terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../modules/networking/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
}

module "subnet" {
  source = "../modules/networking/subnet"

  vpc_id = module.vpc.vpc_id

  public_subnet_cidr_blocks         = var.public_subnet_cidr_blocks
  public_subnet_names               = var.public_subnet_names
  public_subnet_availability_zones  = var.public_subnet_availability_zones
  private_subnet_cidr_blocks        = var.private_subnet_cidr_blocks
  private_subnet_names              = var.private_subnet_names
  private_subnet_availability_zones = var.private_subnet_availability_zones
}

module "network_interface" {
  source = "../modules/networking/network_interface"

  vpc_id                    = module.vpc.vpc_id
  public_subnets            = module.subnet.public_subnets
  private_subnets           = module.subnet.private_subnets 

  nat_gateway_name          = var.nat_gateway_name
  internet_gateway_name     = var.internet_gateway_name
  private_route_table_name  = var.private_route_table_name
  public_route_table_name   = var.public_route_table_name
  internet_cidr_block       = var.internet_cidr_block
}

module "security_group" {
  source = "../modules/instances/security_group"

  vpc_id                                = module.vpc.vpc_id
}

module "EC2" {
  source = "../modules/instances/EC2"

  subnet_ids_list_map       = module.subnet.subnet_ids_list_map
  tunefy_nginx_SG_id        = module.security_group.tunefy_nginx_SG_id
  tunefy_bastion_SG_id      = module.security_group.tunefy_bastion_SG_id
  tunefy_frontend_SG_id     = module.security_group.tunefy_frontend_SG_id
  tunefy_backend_SG_id      = module.security_group.tunefy_backend_SG_id
  tunefy_database_SG_id     = module.security_group.tunefy_database_SG_id
  tunefy_k8s_master_SG_id   = module.security_group.tunefy_k8s_master_SG_id
  tunefy_cicd_SG_id         = module.security_group.tunefy_cicd_SG_id

  bastion_provision_script  = module.scripts.bastion_provision_script
  nginx_provision_script    = module.scripts.nginx_provision_script
}

module "load_balancer" {
  source = "../modules/instances/load_balancer"
  
  vpc_id                              = module.vpc.vpc_id
  public_subnets                      = module.subnet.public_subnets
  private_subnets                     = module.subnet.private_subnets
  internet_facing_load_balancer_name  = var.internet_facing_load_balancer_name
  backend_load_balancer_name          = var.backend_load_balancer_name 
  nginx_instances_id_list             = module.EC2.nginx_instances_id_list
  backend_instances_id_list           = module.EC2.backend_instances_id_list
}

module "security_group_rule" {
  source = "../modules/instances/security_group_rule"

  internet_facing_load_balancer_exists  = module.load_balancer.internet_facing_load_balancer_exists
  tunefy_nginx_SG_id        = module.security_group.tunefy_nginx_SG_id
  tunefy_bastion_SG_id      = module.security_group.tunefy_bastion_SG_id
  tunefy_frontend_SG_id     = module.security_group.tunefy_frontend_SG_id
  tunefy_backend_SG_id      = module.security_group.tunefy_backend_SG_id
  tunefy_database_SG_id     = module.security_group.tunefy_database_SG_id
  tunefy_k8s_master_SG_id   = module.security_group.tunefy_k8s_master_SG_id
  tunefy_cicd_SG_id         = module.security_group.tunefy_cicd_SG_id

  nginx_instances_ip_list   = module.EC2.nginx_instances_ip_list
  bastion_instance_ip_list  = module.EC2.bastion_instance_ip_list
}

module "scripts" {
  source = "../modules/instances/scripts"

  bastion_instance_ip_list       = module.EC2.bastion_instance_ip_list
}