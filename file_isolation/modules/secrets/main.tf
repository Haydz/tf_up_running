
# This is just code to allow us to simulate grabbing secrets securely
#never hard code credentials
# these could be injected by a CI server at run time, or as env variables
resource "aws_secretsmanager_secret" "example" {
  name = var.db_username
}
 
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    }
  )
}

#  locals {
#     db_creds = jsondecode(aws_secretsmanager_secret_version.example.secret_string
# ) 
#  }


variable "db_username" {
    type = string
    sensitive = true
    description = "DB username passed from sql module"

}
variable "db_password" {
        type = string
    sensitive = true
    description = "DB password passed from sql module"
  
}

// so the mysql module can get these from the statefile
// attempting to avoid depends on issue
# output "db_username" {
#   value = var.db_username
# }

output "secret_id" {
    value = aws_secretsmanager_secret_version.example.arn
  
}