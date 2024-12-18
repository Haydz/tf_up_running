
# //create secret value
resource "aws_secretsmanager_secret" "example" {
  name = "db-creds"
}
 
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    username = "db_user"
    password = "db_pass"
    }
  )
}

 locals {
    db_creds = jsondecode(aws_secretsmanager_secret_version.example.secret_string
) 
 }
output "credentials" {
    value = jsondecode(aws_secretsmanager_secret_version.example.secret_string)
    sensitive =  true
    }

