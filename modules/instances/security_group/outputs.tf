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

output "tunefy_database_SG_id" {
  value = aws_security_group.tunefy-database-SG.id
}

output "tunefy_k8s_master_SG_id" {
  value = aws_security_group.tunefy-k8s-master-SG.id
}

output "tunefy_cicd_SG_id" {
  value = aws_security_group.tunefy-cicd-SG.id
}