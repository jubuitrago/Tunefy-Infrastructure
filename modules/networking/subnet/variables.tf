#VPC ID
variable "vpc_id" {
  type = string
  default = ""
}


#PUBLIC SUBNETS
variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = []  
}

variable "public_subnet_names" {
  description = "Names for the public subnets"
  type        = list(string)
  default     = []
}

variable "public_subnet_availability_zones" {
  description = "AZs for each public subnet"
  type        = list(string)
  default     = []
}


#PRIVATE SUBNETS
variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Names for the private subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_availability_zones" {
  description = "AZs for each private subnet"
  type        = list(string)
  default     = []
}