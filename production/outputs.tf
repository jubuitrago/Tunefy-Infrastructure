output "vpc_id" {
  value = aws_vpc.production.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production.cidr_block
}
