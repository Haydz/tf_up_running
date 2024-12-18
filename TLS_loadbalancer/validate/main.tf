locals {
    domain = "haydnjohnson.xyz"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain
  validation_method = "DNS"

  tags = {
    Environment = "haydn-test"
  }

    subject_alternative_names = [
    "www.haydnjohnson.xyz"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

#Validate the certificate
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.resource_record_name]
}

# Outputs
output "certificate_arn" {
  description = "The ARN of the issued certificate"
  value       = aws_acm_certificate.cert.arn
}

output "validation_status" {
  description = "Validation status of the certificate"
  value       = aws_acm_certificate_validation.cert_validation.id != "" ? "SUCCESS" : "PENDING"
}
