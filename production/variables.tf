#REGION
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1" 
}

#VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/24"  
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "Tunefy-production-IAC"
}


#PUBLIC SUBNETS
variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]  
}

variable "public_subnet_names" {
  description = "Names for the public subnets"
  type        = list(string)
  default     = ["public-subnet-nginx-1a", "public-subnet-nginx-1b", "public-subnet-bastion-1a"]
}

variable "public_subnet_availability_zones" {
  description = "AZs for each public subnet"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1a"]
}


#PRIVATE SUBNETS
variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.0.48/28", "10.0.0.64/28", "10.0.0.80/28", "10.0.0.96/28", "10.0.0.112/28"]
}

variable "private_subnet_names" {
  description = "Names for the private subnets"
  type        = list(string)
  default     = ["private-subnet-app-1a", "private-subnet-app-1b", "private-subnet-k8s-master-1a", "private-subnet-k8s-master-1b", "private-subnet-CICD-1a"]
}

variable "private_subnet_availability_zones" {
  description = "AZs for each private subnet"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b", "us-east-1a"]
}


#NETWORK INTERFACES
variable "internet_gateway_name" {
  description = "Name for the internet gateway"
  type        = string
  default     = "tunefy-IGW"
}

variable "public_route_table_name" {
  description = "Name for the public route table"
  type        = string
  default     = "tunefy-rtb-public"
}

variable "nat_gateway_name" {
  description = "Name for the NAT gateway"
  type        = string
  default     = "tunefy-NAT-GW"
}

variable "private_route_table_name" {
  description = "Name for the private route table"
  type        = string
  default     = "tunefy-rtb-private"
}

variable "internet_cidr_block" {
  description = "CIDR for internet"
  type        = string
  default     = "0.0.0.0/0"
}