output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "subnet_ids_list_map" {
  value = tomap({
    "nginx"               = [for subnet in aws_subnet.public : subnet.id if subnet.tags.Name == "public-subnet-nginx-1a" || subnet.tags.Name == "public-subnet-nginx-1b"],
    "frontend"            = [for subnet in aws_subnet.private : subnet.id if subnet.tags.Name == "private-subnet-app-1a" || subnet.tags.Name == "private-subnet-app-1b"],
    "backend"             = [for subnet in aws_subnet.private : subnet.id if subnet.tags.Name == "private-subnet-app-1a" || subnet.tags.Name == "private-subnet-app-1b"],
    "primary_database"    = [for subnet in aws_subnet.private : subnet.id if subnet.tags.Name == "private-subnet-app-1a"],
    "replica_database"    = [for subnet in aws_subnet.private : subnet.id if subnet.tags.Name == "private-subnet-app-1b"],
    "cicd"                = [for subnet in aws_subnet.private : subnet.id if subnet.tags.Name == "private-subnet-cicd-1a" || subnet.tags.Name == "private-subnet-cicd-1b"],
    "k8s_master"          = [for subnet in aws_subnet.private : subnet.id if subnet.tags.Name == "private-subnet-k8s-master-1a" || subnet.tags.Name == "private-subnet-k8s-master-1b"],
    "bastion"             = [for subnet in aws_subnet.public : subnet.id if subnet.tags.Name == "public-subnet-bastion-1a" || subnet.tags.Name == "public-subnet-bastion-1b"]
  })
}