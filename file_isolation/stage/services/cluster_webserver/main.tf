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
    key    = "webserver_terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "<YOUR DYNAMODB TABLE>"
    encrypt = true
  }
}


module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "haydz-staging_test"
  instance_type = "t2.micro"
  environment = "staging"
  db_remote_state_bucket = "haydn-test-stuff-2"
  db_remote_state_key = "mysql_terraform.tfstate"
  enable_autoscaling = false
      custom_tags = {
        Owner = "Haydn"
        ManagedBy = "terraform"
    }
  
 server_text = "test"
}

# output "db_remote_state_debug" {
#   value = data.terraform_remote_state.db.outputs
# }



//adding a security group rule to the module
# resource "aws_security_group_rule" "allow_testing_inbound" {
#   type = "ingress"
#   security_group_id = module.webserver_cluster.alb_security_group_id
#   from_port = 80
#   to_port = 80
#   protocol = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }

output "domain" {
  value = module.webserver_cluster.alb_dns_name
}