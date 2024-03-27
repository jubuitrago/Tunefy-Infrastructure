output "tunefy_nginx_SG_id" {
  value = aws_security_group.tunefy-nginx-SG.id
}

output "tunefy_bastion_SG_id" {
  value = aws_security_group.tunefy-bastion-SG.id
}

output "tunefy_frontend_SG_id" {
  value = aws_security_group.tunefy-frontend-SG.id
}

output "tunefy_backend_SG_id" {
  value = aws_security_group.tunefy-backend-SG.id
}

output "tunefy_primary_database_SG_id" {
  value = aws_security_group.tunefy-primary-database-SG.id
}

output "tunefy_replica_database_SG_id" {
  value = aws_security_group.tunefy-replica-database-SG.id
}

output "tunefy_k8s_master_SG_id" {
  value = aws_security_group.tunefy-k8s-master-SG.id
}

output "tunefy_cicd_SG_id" {
  value = aws_security_group.tunefy-cicd-SG.id
}

output "SG_ids_list" {
  value = [
    aws_security_group.tunefy-nginx-SG.id,
    aws_security_group.tunefy-frontend-SG.id,
    aws_security_group.tunefy-backend-SG.id,
    aws_security_group.tunefy-primary-database-SG.id,
    aws_security_group.tunefy-replica-database-SG.id,
    aws_security_group.tunefy-k8s-master-SG.id,
    aws_security_group.tunefy-cicd-SG.id
  ]
}