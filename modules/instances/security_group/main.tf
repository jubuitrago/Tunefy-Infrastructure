#TUNEFY-NGINX-SG
resource "aws_security_group" "tunefy-nginx-SG" {
    name = "tunefy-nginx-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-nginx-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


#TUNEFY-BASTION-SG
resource "aws_security_group" "tunefy-bastion-SG" {
    name = "tunefy-bastion-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-bastion-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


#TUNEFY-FRONTEND-SG
resource "aws_security_group" "tunefy-frontend-SG" {
    name = "tunefy-frontend-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-frontend-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


#TUNEFY-BACKEND-SG
resource "aws_security_group" "tunefy-backend-SG" {
    name = "tunefy-backend-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-backend-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


#TUNEFY-DATABASE-SG
resource "aws_security_group" "tunefy-primary-database-SG" {
    name = "tunefy-primary-database-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-primary-database-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "tunefy-replica-database-SG" {
    name = "tunefy-replica-database-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-replica-database-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


#TUNEFY-K8S-MASTER-SG
resource "aws_security_group" "tunefy-k8s-master-SG" {
    name = "tunefy-k8s-master-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-k8s-master-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


#TUNEFY-CICD-SG
resource "aws_security_group" "tunefy-cicd-SG" {
    name = "tunefy-cicd-iac-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-cicd-iac-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

#INTERNET-FACING-SG
resource "aws_security_group" "tunefy-internet-facing-ALB-SG" {
    name = "tunefy-internet-facing-ALB-SG"
    vpc_id = var.vpc_id
    tags = {
        Name = "tunefy-internet-facing-ALB-SG"
    }
    egress {
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}