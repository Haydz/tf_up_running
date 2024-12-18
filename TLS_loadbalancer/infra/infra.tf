# need provider

provider "aws" {
 region = "us-east-1"
}

# create instance -> should default to default VPC


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_security_group" "example" {
  id = "xxx"
}


resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = data.aws_security_group.example.id

  cidr_ipv4   = "0.0.0.0/0"
#   from_port   = 8080
  ip_protocol = -1
#   to_port     = 8080
}

# resource "aws_vpc_security_group_egress_rule" "example" {
#   security_group_id = data.aws_security_group.example.id

#   cidr_ipv4   = "0.0.0.0/0"
# #   from_port   = -1
#   ip_protocol = -1
# #   to_port     = -1
# }


# can be changed to a for_each  loop
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id  = "xx-xx"
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id  = "xx-xx"
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "HelloWorld2"
  }
}

output "external_IP" {
    value = aws_instance.web.public_ip
}

output "instance_id"{
  value = aws_instance.web.id
}

output "instance2_id2"{
  value = aws_instance.web2.id
}

output "instances" {
  value = {
    web1 = aws_instance.web.id
    web2 = aws_instance.web2.id
  }
}

output "sg_id" {
  value = data.aws_security_group.example.id
}