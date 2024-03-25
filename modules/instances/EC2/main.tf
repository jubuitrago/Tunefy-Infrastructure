resource "aws_instance" "nginx" {
    count = length(var.subnet_ids_list_map["nginx"])

    subnet_id                   = var.subnet_ids_list_map["nginx"][count.index]
    instance_type               = "t2.nano"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_nginx_SG_id]
    user_data                   = var.nginx_provision_script

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

    tags = {
        Name = "tunefy-backend"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "database" {
    count = length(var.subnet_ids_list_map["database"])

    subnet_id                   = var.subnet_ids_list_map["database"][count.index]
    instance_type               = "t2.small"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_database_SG_id] 

    tags = {
        Name = "tunefy-database"
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

    tags = {
        Name = "tunefy-cicd"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "k8s-master" {
    count = length(var.subnet_ids_list_map["k8s-master"])

    subnet_id                   = var.subnet_ids_list_map["k8s-master"][count.index]
    instance_type               = "t2.medium"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = false
    key_name                    = "tunefy-global-key"
    vpc_security_group_ids      = [var.tunefy_k8s_master_SG_id] 


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