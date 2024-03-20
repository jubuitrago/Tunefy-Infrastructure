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