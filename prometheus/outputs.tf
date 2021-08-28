output "prometheus_console_security_group_id" {
  value = aws_security_group.prometheus_traffic.id
}
