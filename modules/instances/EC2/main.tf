resource "aws_instance" "nginx" {
    for_each = {
        for subnet in var.public_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "public-subnet-nginx-1a" || subnet.tags.Name == "public-subnet-nginx-1b")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.nano"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-global-key"

    tags = {
        Name = "tunefy-nginx-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "frontend" {
    for_each = {
        for subnet in var.private_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "private-subnet-app-1a" || subnet.tags.Name == "private-subnet-app-1b")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.micro"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-global-key"

    tags = {
        Name = "tunefy-frontend-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "backend" {
    for_each = {
        for subnet in var.private_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "private-subnet-app-1a" || subnet.tags.Name == "private-subnet-app-1b")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.micro"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-global-key"

    tags = {
        Name = "tunefy-backend-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "database" {
    for_each = {
        for subnet in var.private_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "private-subnet-app-1a" || subnet.tags.Name == "private-subnet-app-1b")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.small"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-global-key"

    tags = {
        Name = "tunefy-database-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "cicd" {
    for_each = {
        for subnet in var.private_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "private-subnet-cicd-1a")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.small"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-global-key"

    tags = {
        Name = "tunefy-cicd-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "k8s-master" {
    for_each = {
        for subnet in var.private_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "private-subnet-k8s-master-1a" || subnet.tags.Name == "private-subnet-k8s-master-1b")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.medium"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-global-key"

    tags = {
        Name = "tunefy-k8s-master-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}

resource "aws_instance" "bastion" {
    for_each = {
        for subnet in var.public_subnets:
        subnet.id => subnet if contains(keys(subnet.tags), "Name") && (subnet.tags.Name == "public-subnet-bastion-1a")
    }

    subnet_id                   = each.value.id
    instance_type               = "t2.medium"
    ami                         = "ami-080e1f13689e07408"
    associate_public_ip_address = true
    key_name = "tunefy-bastion-key"

    tags = {
        Name = "tunefy-bastion-${substr(each.value.tags.Name, -2, 0)}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = 8
    }
}