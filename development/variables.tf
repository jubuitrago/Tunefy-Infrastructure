#REGION
variable "aws_region" {
  type = string
  default     = "" 
}


#VPC
variable "vpc_cidr_block" {
  type = string
  default     = ""  
}
variable "vpc_name" {
  type = string
  default     = ""
}


#PUBLIC SUBNETS
variable "public_subnet_cidr_blocks" {
  type = list(string)
  default     = []  
}
variable "public_subnet_names" {
  type = list(string)
  default     = []
}
variable "public_subnet_availability_zones" {
  type = list(string)
  default     = []
}


#PRIVATE SUBNETS
variable "private_subnet_cidr_blocks" {
  type = list(string)
  default     = []
}
variable "private_subnet_names" {
  type = list(string)
  default     = []
}
variable "private_subnet_availability_zones" {
  type = list(string)
  default     = []
}


#NETWORK INTERFACES
variable "internet_gateway_name" {
  type = string
  default     = ""
}
variable "public_route_table_name" {
  type = string
  default     = ""
}
variable "internet_cidr_block" {
  type = string
  default     = ""
}
variable "nat_gateway_name" {
  type = string
  default     = ""
}
variable "private_route_table_name" {
  type = string
  default     = ""
}

#LOAD BALANCERS
variable "internet_facing_load_balancer_name" {
  type = string
  default = ""
}

variable "backend_load_balancer_name" {
  type = string
  default = ""
}