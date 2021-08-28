output "target_group" {
  value = aws_lb_target_group.ecs_task
}

output "dns_name" {
  value = aws_lb.main.dns_name
}

output "arn" {
  value = aws_lb.main.arn
}

output "security_group" {
  value = aws_security_group.alb
}

output "public_route53_fqdn" {
  value = aws_route53_record.alb.fqdn
}
