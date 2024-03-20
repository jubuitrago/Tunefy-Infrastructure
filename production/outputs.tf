output "vpc_id" {
  value = aws_vpc.production.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production.cidr_block
}

output "vpc_name" {
  value = aws_vpc.production.tags["Name"]
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
