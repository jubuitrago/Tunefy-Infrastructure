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

resource "aws_vpc" "production" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.production.id
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

resource "aws_subnet" "private" {
  count                  = length(var.private_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.production.id
  cidr_block             = var.private_subnet_cidr_blocks[count.index]
  tags = {
    Name = var.private_subnet_names[count.index]
  }
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
