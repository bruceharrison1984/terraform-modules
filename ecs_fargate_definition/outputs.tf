output "task_definition_json" {
  value = jsonencode(local.definition)
}

output "task_definition" {
  value = local.definition
}

output "task_name" {
  value = var.task_name
}

output "execution_policy_arn" {
  value = aws_iam_policy.ecs_execution_policy.arn
}

output "task_policy_arn" {
  value = aws_iam_policy.ecs_task_policy.arn
}

output "log_group" {
  value = local.log_group
}
