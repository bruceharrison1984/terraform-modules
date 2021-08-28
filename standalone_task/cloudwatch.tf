resource "aws_cloudwatch_log_group" "standalone" {
  name              = "/ecs/${terraform.workspace}/${module.standalone_task.task_name}"
  retention_in_days = 14
  kms_key_id        = var.kms_key_arn
  tags = {
    Name = "/ecs/${terraform.workspace}/${module.standalone_task.task_name}"
  }
}
