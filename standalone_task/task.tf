## this task is run as a one-off task outside of an ECS Service

module "standalone_task" {
  source                 = "../ecs_fargate_definition"
  task_name              = var.task_name
  container_name         = var.container
  repository_credentials = var.github_registry_credentials_arn
  secrets                = var.secrets
  environment_variables  = var.environment_variables
  kms_key_arn            = var.kms_key_arn
  ssm_parameter_root_arn = var.ssm_parameter_root_arn
}

resource "aws_ecs_task_definition" "standalone" {
  family                   = "${var.task_name}-${terraform.workspace}"
  task_role_arn            = aws_iam_role.standalone_task.arn
  execution_role_arn       = aws_iam_role.standalone_execution.arn
  cpu                      = 1024 ## 1 vCPU
  memory                   = 2048 ## 2Gb RAM
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = jsonencode([module.standalone_task.task_definition])

  tags = {
    Name = "${var.task_name}-${terraform.workspace}"
  }

  depends_on = [
    aws_cloudwatch_log_group.standalone
  ]
}
