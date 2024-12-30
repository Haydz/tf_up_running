provider "aws" {
    region = "us-east-1"
}



module "asg" {
    source = "../"
    subnet_ids = local.unique_subnets
    environment = "staging"
    # cluster_name = var.cluster_name
    # ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    cluster_name = "haydn-staging"
    instance_id = data.aws_ami.ubuntu.id
    

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



data "aws_ami" "ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical
    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] 
    }
}


output "intance_security_group_id" {
    value = module.asg.intance_security_group_id
    description = "The name of the Auto Scaling Group"
}

