resource "aws_vpc" "production" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}