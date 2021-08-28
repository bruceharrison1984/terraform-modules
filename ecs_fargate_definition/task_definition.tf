data "aws_region" "current" {}

locals {
  log_group         = var.log_group == null ? "/ecs/${terraform.workspace}/${var.task_name}" : var.log_group
  log_stream_prefix = var.log_stream_prefix == null ? var.task_name : var.log_stream_prefix

  definition = {
    name  = var.task_name
    image = "${var.container_name}:${var.container_tag}"
    repositoryCredentials = var.repository_credentials != null ? {
      credentialsParameter = var.repository_credentials
    } : null
    essential    = true
    secrets      = [for k, v in var.secrets : { name = k, valueFrom = v }]
    environment  = [for k, v in var.environment_variables : { name = k, value = v }]
    portMappings = var.port_mappings
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = local.log_group
        awslogs-stream-prefix = local.log_stream_prefix
        awslogs-region        = data.aws_region.current.name
      }
    }
    dockerLabels = var.docker_labels
  }
}
