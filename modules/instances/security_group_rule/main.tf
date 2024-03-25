#TUNEFY-NGINX-SG RULES
resource "aws_vpc_security_group_ingress_rule" "allow_HTTP80_from_public_alb" {
    security_group_id = var.tunefy_nginx_SG_id
    cidr_ipv4   = var.internet_facing_load_balancer_exists ? "10.0.0.0/27" : "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
}

#TUNEFY-BASTION-SG RULES
resource "aws_vpc_security_group_ingress_rule" "allow_SSH22_from_admin_pc" {
    count = length(var.nginx_instances_ip_list)

    security_group_id = var.tunefy_bastion_SG_id
    cidr_ipv4 = var.nginx_instances_ip_list[count.index]
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
}