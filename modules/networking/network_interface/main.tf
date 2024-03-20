#INTERNET GATEWAY
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
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
  count             = length(var.public_subnets)
  subnet_id         = var.public_subnets[count.index].id
  route_table_id    = aws_route_table.public.id
}

#NAT GATEWAY
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnets[2].id
  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
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
  count               = length(var.private_subnets)
  subnet_id           = var.private_subnets[count.index].id
  route_table_id      = aws_route_table.private.id
}

