# terraform {
#   required_version = ">= 1.0.0, < 2.0.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

# module "users" {
#   source    = "../../modules/landing-zone/iam-user"
#   count     = length(var.user_names)
#   user_name = var.user_names[count.index]
# }

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
} 


# output "user_arns" {
#   value       = module.users[*].user_arn
#   description = "The ARNs of the created IAM users"
# }

module "users" {
    source = "../../modules/landing-zone/iam-user"
    for_each =  toset(var.user_names )
    user_name = each.value
}

output "user_arns" {
    value = values(module.users)[*].user_an
}


