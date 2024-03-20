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

#VPC
resource "aws_vpc" "production" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

#SUBNETS
resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.production.id
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  availability_zone      = var.public_subnet_availability_zones[count.index]
  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

resource "aws_subnet" "private" {
  count                  = length(var.private_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.production.id
  cidr_block             = var.private_subnet_cidr_blocks[count.index]
  availability_zone      = var.private_subnet_availability_zones[count.index]
  tags = {
    Name = var.private_subnet_names[count.index]
  }
}

#INTERNET GATEWAY
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route" "internet_gateway" {
  route_table_id          = aws_route_table.public.id
  destination_cidr_block  = var.internet_cidr_block
  gateway_id              = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_subnet_associations" {
  count             = length(aws_subnet.public)
  subnet_id         = aws_subnet.public[count.index].id
  route_table_id    = aws_route_table.public.id
}

#NAT GATEWAY
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[2].id
  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_route" "nat_gateway" {
  route_table_id           = aws_route_table.private.id
  destination_cidr_block   = var.internet_cidr_block
  nat_gateway_id           = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private_subnet-associations" {
  count               = length(aws_subnet.private)
  subnet_id           = aws_subnet.private[count.index].id
  route_table_id      = aws_route_table.private.id
}

