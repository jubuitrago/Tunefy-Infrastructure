resource "aws_security_group" "allow_HTTP80_from_public_alb" {
  name = "allow_HTTP:80_from_public_alb"
  vpc_id = var.vpc_id
  tags = {
    Name = "allow_HTTP:80_from_public_alb"
  }

  egress = {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP80_from_public_alb" {

}