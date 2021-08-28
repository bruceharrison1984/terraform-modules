
resource "aws_ecs_task_definition" "private" {
  family                   = "${var.task_name}-${terraform.workspace}"
  task_role_arn            = aws_iam_role.private_task.arn
  execution_role_arn       = aws_iam_role.private_execution.arn
  cpu                      = var.cpu_reservation
  memory                   = var.memory_reservation
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = var.create_xray_task ? jsonencode([module.private_task.task_definition, module.private_xray_task.task_definition, ]) : jsonencode([module.private_task.task_definition])

  depends_on = [
    aws_cloudwatch_log_group.private
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      container_definitions
    ]
  }
}

resource "aws_ecs_service" "private_service" {
  name                               = var.task_name
  cluster                            = var.ecs_cluster.name
  task_definition                    = aws_ecs_task_definition.private.arn
  desired_count                      = var.default_task_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets         = var.private_subnets
    security_groups = var.task_security_group_ids
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.private_task.arn
    container_name = var.task_name
  }

  ## these prevent a race condition during deletion
  depends_on = [
    aws_iam_role_policy_attachment.private_execution,
    aws_iam_role_policy_attachment.private_task_xray,
    aws_iam_role_policy_attachment.private_task_application,
  ]

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}
