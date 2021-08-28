output "aurora_internal_endpoint" {
  value = aws_rds_cluster.postgresql.endpoint
}

output "security_group" {
  value = aws_security_group.aurora
}

