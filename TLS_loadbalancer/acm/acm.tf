#configure domain
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

#using rebel not AWS cant use below
# resource "aws_route53_record" "cert_validation_record" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.selected_zone.zone_id
# }

# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.resource_record_name]
# }

output "cname_validation_records" {
  value = [
    for dvo in aws_acm_certificate.cert.domain_validation_options : {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  ]
}

# Request the certificate
# resource "aws_acm_certificate" "cert" {
#   domain_name       = local.domain
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Environment = "haydn-test"
#   }
# }

#Validate the certificate
# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.resource_record_name]
# }

# Outputs
output "certificate_arn" {
  description = "The ARN of the issued certificate"
  value       = aws_acm_certificate.cert.arn
}

# output "validation_status" {
#   description = "Validation status of the certificate"
#   value       = aws_acm_certificate_validation.cert_validation.id != "" ? "SUCCESS" : "PENDING"
# }



# resource "aws_acm_certificate" "cert" {
#   domain_name       = local.domain
#   validation_method = "EMAIL"

#   validation_option {
#     domain_name       = local.domain
#     validation_domain = local.domain
#   }  
#   lifecycle {
#     create_before_destroy = true
#   }
# }