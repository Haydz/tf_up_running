# this launches the app into 
terraform {
  # Require any 1.x version of Terraform
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  unique_subnets = [
    for subnet in data.aws_subnet.details :
    subnet.id if length([
      for other in data.aws_subnet.details :
      other.id if other.availability_zone == subnet.availability_zone
    ]) == 1
  ]
}



module "asg" {
  source             = "../../cluster/asg-rolling-deploy"
  cluster_name       = "cluster-${var.environment}"
  enable_autoscaling = var.enable_autoscaling
  instance_type      = var.instance_type
  environment        = var.environment

  user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    server_text = var.server_text
  })

  # min & max size are determined by the enviornment

  # need to figure out subnet ids
  # think take it from ASG into root modules?
  subnet_ids        = local.unique_subnets
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  custom_tags       = var.custom_tags


}


module "loadbalancer" {
  source     = "../../networking/alb"
  alb_name   = "haydn-test-${var.environment}"
  subnet_ids = local.unique_subnets
}


resource "aws_lb_target_group" "asg" {

  name = "hello-world-${var.environment}"

  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = var.db_remote_state_key
    region = "us-east-1"
  }
}




variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}