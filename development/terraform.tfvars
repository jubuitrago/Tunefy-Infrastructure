#REGION
aws_region = "us-east-1"

#VPC
vpc_cidr_block = "10.0.0.0/25"
vpc_name = "Tunefy-development-IAC"

#PUBLIC SUBNETS
public_subnet_cidr_blocks               = ["10.0.0.0/28", "10.0.0.16/28", ]
public_subnet_names                     = ["public-subnet-nginx-1a", "public-subnet-bastion-1a"]
public_subnet_availability_zones        = ["us-east-1a", "us-east-1a"]

#PRIVATE SUBNETS
private_subnet_cidr_blocks              = ["10.0.0.32/28" , "10.0.0.48/28", "10.0.0.64/28"]
private_subnet_names                    = ["private-subnet-app-1a", "private-subnet-k8s-master-1a", "private-subnet-cicd-1a"]
private_subnet_availability_zones       = ["us-east-1a", "us-east-1a", "us-east-1a"]

#NAT GATEWAY
nat_gateway_name                        = "tunefy-NAT-GW"
private_route_table_name                = "tunefy-rtb-private"

#INTERNET GATEWAY
internet_gateway_name                   = "tunefy-IGW"
public_route_table_name                 = "tunefy-rtb-public"

#INTERNET
internet_cidr_block                     = "0.0.0.0/0"

#INTERNET-FACING LOAD BALANCER
internet_facing_load_balancer_name      = "tunefy-public-ALB"

#BACKEND LOAD BALANCER                  
backend_load_balancer_name              = "tunefy-backend-ALB"