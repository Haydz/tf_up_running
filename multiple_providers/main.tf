provider "aws" {
  region = "us-east-1"
  alias = "aws1"
}


provider "aws" {
  region = "us-east-2"
  alias = "aws2"
}
  
    data "aws_region" "region_1" {
    provider = aws.aws1
}

    data "aws_region" "region_2" {
    provider = aws.aws2
}

output "aws1" {
    value = data.aws_region.region_1.id
  
}

locals {
    aws_regions = [
        data.aws_region.region_1,
        data.aws_region.region_2
    ]
}

output "region_ids" {
    value = [for region in local.aws_regions: region.id]
}

output "all_regions" {
    value = local.aws_regions
}


data "aws_ami" "ubuntu_region_1" {
    provider = aws.aws1
    most_recent = true
    owners = ["099720109477"] # Canonical


filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
       }
}

output "ami" {
    value = data.aws_ami.ubuntu_region_1.id
  
}

data "aws_ami" "ubuntu_region_2" {
    provider = aws.aws2
    most_recent = true
    owners = ["099720109477"] # Canonical


filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
       }
}

output "ami2" {
    value = data.aws_ami.ubuntu_region_2.id
  
}