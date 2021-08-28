resource "aws_cloudwatch_log_group" "ecs_prometheus" {
  name              = "/ecs/${terraform.workspace}/ecs-prometheus"
  retention_in_days = var.cloudwatch_retention_period
  kms_key_id        = var.kms_key_arn
  tags = {
    Name = "/ecs/${terraform.workspace}/ecs-prometheus"
  }
}
