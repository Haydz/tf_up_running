locals {
  db_name = "production_db"
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

 backend "s3" {
    bucket         = "haydn-test-stuff-2"
    key            = "prod_mysql_terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "<YOUR DYNAMODB TABLE>"
    encrypt        = true
  }
  
}

module "mysql" {
    db_username = var.db_username
    db_password = var.db_password
    db_name = local.db_name
     source = "../../../modules/services/datastore/mysql"
  
}