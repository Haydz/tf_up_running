variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = "terraform-asg-example"
}

variable "subnet_ids" {
  description = "The ip addresses for the load balancer"
  type        = list(string)
}

