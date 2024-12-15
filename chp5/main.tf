variable "user_names" {
	description = "Create Iam Users with these names"
	type = list(string)
	default = ["neo", "trinity", "morpheus"]
}
variable "names" {
description = "Names to render"
type = list(string)
default = ["neo", "trinity", "morpheus"]
}


resource "aws_iam_user" "example" { 
    for_each = toset(var.user_names) 
    name = each.value
}


  output "all_users" {
    value = aws_iam_user.example
}

# for ARNS
output "all_arns" {
    value = values(aws_iam_user.example)[*].arn
}

output "upper_names" {
  value = [for name in var.user_names : upper(name)]
}

variable "hero_thousand_faces" {
  description = "map"
  type = map(string)
  default = {
    "neo" = "hero"
    "trinity" = "love interest"
    morpheus = "mentor"
  }
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
  
}

output "upper_roles" {
  value = {for name, role in var.hero_thousand_faces : upper(name) => upper(role)}
}

 output "for_directive" {
    value = "%{ for name in var.names }${name}, %{ endfor }"
}

  output "for_directive_index" {
    value = "%{ for i, name in var.names }(${i}) ${name}, %{ endfor }"
}