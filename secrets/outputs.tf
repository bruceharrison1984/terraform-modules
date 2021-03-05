output "secret_arns" {
  value = zipmap(keys(aws_secretsmanager_secret_version.map_secret), values(aws_secretsmanager_secret_version.map_secret)[*].arn)
}