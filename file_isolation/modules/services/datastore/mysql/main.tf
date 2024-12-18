# locals {
#   bucket_name = "haydn-test-stuff-2"
# }

# terraform {
#   required_version = ">= 1.0.0, < 2.0.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }

#  backend "s3" {


#     bucket         = local.bucket_name
#     key            = "mysql_terraform.tfstate"
#     region         = "us-east-1"
#     # dynamodb_table = "<YOUR DYNAMODB TABLE>"
#     encrypt        = true
#   }as
  
# }

provider "aws" {
  region = "us-east-1"
  
}

variable "secret_id" {
  type = string
  description = "Secret ID of the database credentials"
}

data  "aws_secretsmanager_secret_version" "example" {
  secret_id     = var.secret_id
}


locals {
    db_creds = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)
}





resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t4g.micro"
  db_name             = var.db_name
  # I think this is preferred to be a module
  # Since for testing the creds are being created at database time
  # need a way to give different enviornment creds (prod / stag)
  # a module can be created and used by the root modules!
  username            = local.db_creds["username"]
  password            = local.db_creds["password"]
  skip_final_snapshot = true
}
