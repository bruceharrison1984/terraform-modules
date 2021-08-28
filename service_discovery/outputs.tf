output "private_zone_id" {
  value = aws_service_discovery_private_dns_namespace.private.hosted_zone
}

output "private_zone_fqdn" {
  value = var.private_zone_name
}

output "private_namespace_id" {
  value = aws_service_discovery_private_dns_namespace.private.id
}

output "public_zone_id" {
  value = aws_route53_zone.public.zone_id
}

output "public_zone_fqdn" {
  value = var.public_zone_name
}
