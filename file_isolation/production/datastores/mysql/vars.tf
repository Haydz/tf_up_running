variable "db_username" {
    description = "username for the database"
    type = string
  
}

variable "db_password" {
    description = "Password for the database"
    type = string
    sensitive   = true
  
}