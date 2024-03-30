#TUNEFY-NGINX-SG RULES
resource "aws_vpc_security_group_ingress_rule" "allow_HTTP80_from_public_alb" {
    security_group_id = var.tunefy_nginx_SG_id
    cidr_ipv4   = var.internet_facing_load_balancer_exists ? "10.0.0.0/27" : "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
}

#CHEF-NODES-RULES
resource "aws_vpc_security_group_ingress_rule" "allow_SSH22_from_bastion" {
    count = length(var.SG_ids_list)

    security_group_id   = var.SG_ids_list[count.index]
    cidr_ipv4           = format("%s/32", var.bastion_instance_ip_list[0])
    from_port           = 22
    to_port             = 22
    ip_protocol         = "tcp"
}

#TUNEFY-BASTION-SG RULES
resource "aws_vpc_security_group_ingress_rule" "allow_HTTPS443_from_chef_node_instances" {
    count = length(var.chef_nodes_ip_list)

    security_group_id   = var.tunefy_bastion_SG_id
    cidr_ipv4           = format("%s/32", var.chef_nodes_ip_list[count.index])
    from_port           = 443
    to_port             = 443
    ip_protocol         = "tcp"
}

#K8S-MASTER-SG RULES
resource "aws_vpc_security_group_ingress_rule" "allow_TCP6443_from_k8s_node_instances" {
    count = length(var.k8s_nodes_ip_list)

    security_group_id   = var.tunefy_k8s_master_SG_id
    cidr_ipv4           = format("%s/32", var.k8s_nodes_ip_list[count.index])
    from_port           = 6443
    to_port             = 6443
    ip_protocol         = "tcp"
}

#K8S-NODES-SG RULES
resource "aws_vpc_security_group_ingress_rule" "backend_allow_TCP10250_from_k8s_master_instances" {
    count = length(var.k8s_master_ip_list)

    security_group_id   = var.tunefy_backend_SG_id
    cidr_ipv4           = format("%s/32", var.k8s_master_ip_list[count.index])
    from_port           = 10250
    to_port             = 10251
    ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "frontend_allow_TCP10250_from_k8s_master_instances" {
    count = length(var.k8s_master_ip_list)

    security_group_id   = var.tunefy_frontend_SG_id
    cidr_ipv4           = format("%s/32", var.k8s_master_ip_list[count.index])
    from_port           = 10250
    to_port             = 10251
    ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "frontend_allow_TCP30000_from_nginx_instances" {
    count = length(var.nginx_instances_ip_list)

    security_group_id   = var.tunefy_frontend_SG_id
    cidr_ipv4           = format("%s/32", var.nginx_instances_ip_list[count.index])
    from_port           = 30000
    to_port             = 30000
    ip_protocol         = "tcp"
}

#INTERNET-FACING LOAD BALANCER RULES
resource "aws_vpc_security_group_ingress_rule" "allow_TCP80_from_internet" {
    security_group_id   = var.tunefy_internet_facing_ALB_SG_id
    cidr_ipv4           = "0.0.0.0/0"
    from_port           = 80
    to_port             = 80
    ip_protocol         = "tcp"
}