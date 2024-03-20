#SUBNETS
resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidr_blocks)
  vpc_id                 = var.vpc_id
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  availability_zone      = var.public_subnet_availability_zones[count.index]
  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

resource "aws_subnet" "private" {
  count                  = length(var.private_subnet_cidr_blocks)
  vpc_id                 = var.vpc_id
  cidr_block             = var.private_subnet_cidr_blocks[count.index]
  availability_zone      = var.private_subnet_availability_zones[count.index]
  tags = {
    Name = var.private_subnet_names[count.index]
  }
}