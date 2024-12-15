provider "aws" {
  region = "us-east-1"
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


    bucket = "haydn-test-stuff-2"
    key    = "production_webserver_terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "<YOUR DYNAMODB TABLE>"
    encrypt = true 
  }
}

variable "environment" {
  type    = string
  default = "prod"
}


module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"
    db_remote_state_key = "prod_mysql_terraform.tfstate"
    cluster_name = "haydz-production-test"
    instance_type = "t2.micro"
    environment = var.environment
    # max_size = 2
    enable_autoscaling = true

    custom_tags = {
        Owner = "Haydn"
        ManagedBy = "terraform"
    }

}
