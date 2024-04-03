#INTERNET-FACING LOAD BALANCER
resource "aws_lb" "internet_facing" {
  name = var.internet_facing_load_balancer_name
  internal = false
  load_balancer_type = "application"
  security_groups = [var.tunefy_internet_facing_ALB_SG_id]
  subnets = [for subnet in var.public_subnets : subnet.id if subnet.tags["Name"] == "public-subnet-nginx-1a" || subnet.tags["Name"] == "public-subnet-nginx-1b"]
}

resource "aws_lb_target_group" "nginx_tg" {
  name = "nginx-iac-TG"
  port = "80"
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  health_check {
    path                    = "/"
    port                    = "80"
    protocol                = "HTTP"
    interval                = 15
    timeout                 = 5
    healthy_threshold       = 2
    unhealthy_threshold     = 2
  }
}

resource "aws_lb_listener" "internet_facing" {
  load_balancer_arn = aws_lb.internet_facing.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "nginx_instance" {
  count = length(var.nginx_instances_id_list)

  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id = var.nginx_instances_id_list[count.index]
  port = 80
}


#BACKEND LOAD BALANCER
resource "aws_lb" "backend" {
  name = var.backend_load_balancer_name
  internal = true
  load_balancer_type = "application"
  #security_groups =
  subnets = [for subnet in var.private_subnets : subnet.id if subnet.tags["Name"] == "private-subnet-app-1a" || subnet.tags["Name"] == "private-subnet-app-1b"]
}

resource "aws_lb_target_group" "backend_tg" {
  name = "backend-iac-TG"
  port = "30001"
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  health_check {
    path                    = "/"
    port                    = "30001"
    protocol                = "HTTP"
    interval                = 15
    timeout                 = 5
    healthy_threshold       = 2
    unhealthy_threshold     = 2
    matcher                 = "404"
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "backend_instance" {
  count = length(var.backend_instances_id_list)

  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id = var.backend_instances_id_list[count.index]
  port = 30001
}