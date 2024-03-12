resource "aws_subnet" "subnet-public-proxy-1a" {  #Create subnet-public-proxy-1a
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-public-proxy-1a"
  }
}

resource "aws_subnet" "subnet-public-proxy-1b" {  #Create subnet-public-proxy-1a
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-public-proxy-1b"
  }
}

resource "aws_subnet" "subnet-private-app-1a" {   #Create subnet-private-app-1a
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.32/27"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-private-app-1a"
  }
}

resource "aws_subnet" "subnet-private-app-1b" {   #Create subnet-private-app-1b
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.64/27"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-private-app-1b"
  }
}

resource "aws_subnet" "subnet-public-bastion-1a" {   #Create subnet-public-bastion-1a
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.96/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-public-bastion-1a"
  }
}

resource "aws_subnet" "subnet-public-bastion-1b" {   #Create subnet-public-bastion-1b
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.112/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-public-bastion-1b"
  }
}

resource "aws_subnet" "subnet-private-CICD-1a" {   #subnet-private-CICD-1a
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.128/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-private-CICD-1a"
  }
}

resource "aws_subnet" "subnet-private-CICD-1b" {   #subnet-private-CICD-b
  vpc_id     = aws_vpc.tunefy-VPC.id
  cidr_block = "10.0.0.144/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-private-CICD-1b"
  }
}