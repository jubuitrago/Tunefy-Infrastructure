resource "aws_vpc" "tunefy-VPC" {   #Create VPC
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "tunefy-VPC-iac"
  }
}