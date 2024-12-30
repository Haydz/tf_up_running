variable "number_instances" {
  type = map(map(number))
  default = {
    staging = {
      min_size = 2
      max_size = 2
    }
    prod =  {
      min_size = 3
      max_size = 3
    }
    }
}


variable "instance_id" {
  type = string
}
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g.t2.micro)"
  type        = string
  default     = "t2.micro"
  validation {
    condition = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free tier is allowed: t2.micro | t3.micro"
  }
}


variable "custom_tags" {
  description = "Custom tags for instances in ASG"
  type        = map(string)
  default     = {}
}

variable "server_text" {
  description = "The text the web server should return"
  type = string
  default = "Hello, World!"
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}


variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "The health_check_type must be one of: EC2 | ELB."
  }
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}


variable "enable_autoscaling" {
  description = "If set to true, enable autoscaling"
  type = bool
  default = false
  
}