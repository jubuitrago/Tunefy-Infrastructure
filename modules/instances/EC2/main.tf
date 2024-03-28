resource "aws_instance" "nginx" {
    count = length(var.subnet_ids_list_map["nginx"])

    subnet_id                   = var.subnet_ids_list_map["nginx"][count.index]
    instance_type               = "t2.nano"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_nginx_SG_id]
    user_data                   = var.chef_nodes_provision_scripts[count.index].content

    tags = {
        Name = "tunefy-nginx"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "frontend" {
    count = length(var.subnet_ids_list_map["frontend"])

    subnet_id                   = var.subnet_ids_list_map["frontend"][count.index]
    instance_type               = "t2.micro"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_frontend_SG_id]
    user_data                   = var.chef_nodes_provision_scripts[count.index + 2].content

    tags = {
        Name = "tunefy-frontend"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "backend" {
    count = length(var.subnet_ids_list_map["backend"])

    subnet_id                   = var.subnet_ids_list_map["backend"][count.index]
    instance_type               = "t2.micro"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_backend_SG_id]
    user_data                   = var.chef_nodes_provision_scripts[count.index + 4].content

    tags = {
        Name = "tunefy-backend"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "primary_database" {
    count = length(var.subnet_ids_list_map["primary_database"])

    subnet_id                   = var.subnet_ids_list_map["primary_database"][count.index]
    instance_type               = "t2.small"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_primary_database_SG_id]
    user_data                   = var.chef_nodes_provision_scripts[6].content

    tags = {
        Name = "tunefy-primary-database"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "replica_database" {
    count = length(var.subnet_ids_list_map["replica_database"])

    subnet_id                   = var.subnet_ids_list_map["replica_database"][count.index]
    instance_type               = "t2.small"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_replica_database_SG_id]
    user_data                   = var.chef_nodes_provision_scripts[7].content

    tags = {
        Name = "tunefy-replica-database"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "cicd" {
    count = length(var.subnet_ids_list_map["cicd"])

    subnet_id                   = var.subnet_ids_list_map["cicd"][count.index]
    instance_type               = "t2.small"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_cicd_SG_id] 
    user_data                   = var.chef_nodes_provision_scripts[8].content

    tags = {
        Name = "tunefy-cicd"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "k8s_master" {
    count = length(var.subnet_ids_list_map["k8s_master"])

    subnet_id                   = var.subnet_ids_list_map["k8s_master"][count.index]
    instance_type               = "t2.medium"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_k8s_master_SG_id] 
    user_data                   = var.chef_nodes_provision_scripts[count.index + 9].content

    tags = {
        Name = "tunefy-k8s-master"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "bastion" {
    count = length(var.subnet_ids_list_map["bastion"])

    subnet_id                   = var.subnet_ids_list_map["bastion"][count.index]
    instance_type               = "t2.medium"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name                    = "tunefy-bastion-key"
    vpc_security_group_ids      = [var.tunefy_bastion_SG_id]
    user_data                   = var.bastion_provision_script

    tags = {
        Name = "tunefy-bastion"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}