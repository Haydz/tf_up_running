variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "haydn-test-stuff-2"

}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "environment" {
  type = string
}

variable "enable_autoscaling" {
  description = "If set to true, enable autoscaling"
  type        = bool

}
variable "server_text" {
  description = "The text the web server should return"
  default     = "Hello, World"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g.t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}