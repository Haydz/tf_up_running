output "asg_name" {
    value = aws_autoscaling_group.example.name
    description = "The name of the Auto Scaling Group"

}

output "instance_security_group_id" {
    value = aws_security_group.instance.id
    description = "The name of the Auto Scaling Group"
}



# these allow modifcaations
# attaching custom rules to the security group


