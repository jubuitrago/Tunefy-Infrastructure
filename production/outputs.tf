output "public_subnet_ids" {
  value = module.subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = module.subnet.private_subnets[*].id
}
