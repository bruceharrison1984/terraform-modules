module "private_task" {
  source                 = "../ecs_fargate_definition"
  task_name              = var.task_name
  container_name         = var.container
  repository_credentials = var.github_registry_credentials_arn
  secrets                = var.secrets
  environment_variables  = var.environment_variables
  kms_key_arn            = var.kms_key_arn
  ssm_parameter_root_arn = var.ssm_parameter_root_arn
  log_group              = aws_cloudwatch_log_group.private.name
  docker_labels          = var.docker_labels
}

module "private_xray_task" {
  source                 = "../xray_task_definition"
  region                 = var.region
  log_group              = module.private_task.log_group
  repository_credentials = var.github_registry_credentials_arn
}
