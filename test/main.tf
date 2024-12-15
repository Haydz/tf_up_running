variable triangle{
    type = object({
        s_one=number, 
        s_two=number,
        s_three=number, 
        description=string
        })
}


output triangle_output{
    value = var.triangle
    }

# output "example_sg_output"{
#   value = var.example_sg

# }

# variable "example_sg" {
#     type = object({
#       type = string,
#       from_port = number,
#       protocol = string
#     })
# }

