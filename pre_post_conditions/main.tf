provider "aws" {
  region = "us-east-1"
}

resource "aws_secretsmanager_secret" "example" {
  name = "haydn-outputs"
}
 
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    sauce = "bbq"
    }
  )
}


data "aws_secretsmanager_secret" "secret_id" {
  name = "haydn-outputs"
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secret_id.id

  # Specify version_stage or version_id if applicable
  version_stage = "AWSCURRENT"
}

locals {
  is_valid = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string).sauce == "bbqs"
}
