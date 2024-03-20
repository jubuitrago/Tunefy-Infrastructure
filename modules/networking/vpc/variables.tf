variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = ""  
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = ""
}