locals {
  db_name = "staging_db"
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
    key            = "mysql_terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "<YOUR DYNAMODB TABLE>"
    encrypt        = true
  }
  
}

module "secrets" {
  source = "../../../modules/secrets"
  db_username = var.db_username
  db_password = var.db_password
}

module "mysql" {
    source = "../../../modules/services/datastore/mysql"
    db_name = local.db_name
    secret_id = module.secrets.secret_id
     
  
}
