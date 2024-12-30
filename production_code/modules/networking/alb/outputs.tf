output "alb_domain" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "http_listener_arn" {
  value       = aws_lb_listener.http.arn
  description = "The ARN of the HTTP listener"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}
