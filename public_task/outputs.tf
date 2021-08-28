output "alb_dns_name" {
  value = module.public_alb.dns_name
}

output "alb_arn" {
  value = module.public_alb.arn
}

output "alb_public_fqdn" {
  description = "The public-facing FQDN of the ALB"
  value       = module.public_alb.public_route53_fqdn
}
