variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1" 
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/24"  
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]  
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.0.48/28", "10.0.0.64/28", "10.0.0.80/28", "10.0.0.96/28", "10.0.0.112/28"]
}

variable "public_subnet_names" {
  description = "Names for the public subnets"
  type        = list(string())
  default     = ["public-subnet-nginx-1a", "public-subnet-nginx-1b", "public-subnet-bastion"]
}

variable "private_subnet_names" {
  description = "Names for the private subnets"
  type        = list(string())
  default     = ["private-subnet-app-1a", "private-subnet-app-1b", "private-subnet-k8s-master-1a", "private-subnet-k8s-master-1b", "private-subnet-CICD"]
}