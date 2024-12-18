locals {
  cert_arn = "arn:aws:acm:us-east-1:008963853103:certificate/2991b26d-7ad1-4a45-b1af-1e9c9a3400c6"

}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "selected" {
  id = "vpc-d57d71b0"
}

module "instance" {
  source = "./infra"
}

# create target group
resource "aws_alb_target_group" "test" {
  name     = "tf-haydn-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# register target group
resource "aws_lb_target_group_attachment" "test" {
  for_each         = module.instance.instances
  target_group_arn = aws_alb_target_group.test.arn
  target_id        = each.value
  port             = 8080

}

# resource "aws_lb_target_group_attachment" "test2" {
#   target_group_arn = aws_alb_target_group.test.arn
#   target_id        = module.instance.instance2_id2
#   port             = 8080
# }


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test.arn
  }
}

resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.instance.sg_id
  cidr_blocks       = ["0.0.0.0/0"] # Adjust to your needs
}


resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.instance.sg_id]
  subnets            = ["subnet-e840dbc3", "subnet-8efda1f9"]

  enable_deletion_protection = false



  tags = {
    Environment = "haydn-testing"
  }
}


output "alb_domain" {
  value = aws_lb.test.dns_name

}

# output "alb_ip" {
#     value = aws_lb.test.public_ip
# }