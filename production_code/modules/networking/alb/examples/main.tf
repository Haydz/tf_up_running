module "alb" {
    source = "../"
    subnet_ids = local.unique_subnets
    alb_name = "test"

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

# Fetch detailed information about each subnet
data "aws_subnet" "details" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

# Filter unique subnets by Availability Zone
locals {
  unique_subnets = [
    for subnet_key, subnet in data.aws_subnet.details :
    subnet.id if length([
      for other_key, other in data.aws_subnet.details :
      other.id if other.availability_zone == subnet.availability_zone
    ]) == 1
  ]
}


output "alb_domain" {
  value       = module.alb.alb_domain
  description = "The domain name of the load balancer"
}
