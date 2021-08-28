resource "aws_cloudwatch_log_group" "private" {
  name              = "/ecs/${terraform.workspace}/${var.task_name}"
  retention_in_days = var.cloudwatch_retention_period
  kms_key_id        = var.kms_key_arn
  tags = {
    Name = "/ecs/${terraform.workspace}/${var.task_name}"
  }
}
