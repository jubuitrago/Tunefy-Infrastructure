#VPC ID
variable "vpc_id" {
  type = string
  default = ""
}

#PUBLIC SUBNETS
variable "public_subnets" {}

#PRIVATE SUBNETS
variable "private_subnets" {}

#NETWORK INTERFACES
variable "internet_gateway_name" {
  description = "Name for the internet gateway"
  type        = string
  default     = ""
}

variable "public_route_table_name" {
  description = "Name for the public route table"
  type        = string
  default     = ""
}

variable "internet_cidr_block" {
  description = "CIDR for internet"
  type        = string
  default     = ""
}

variable "nat_gateway_name" {
  description = "Name for the NAT gateway"
  type        = string
  default     = ""
}

variable "private_route_table_name" {
  description = "Name for the private route table"
  type        = string
  default     = ""
}
