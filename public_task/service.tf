module "public_alb" {
  source = "../alb"

  name_prefix = var.name_prefix
  vpc_id      = var.vpc_id

  service_name          = var.task_name
  subnet_ids            = var.public_subnets
  health_check_path     = "/health/ready"
  target_internal_port  = 80
  certificate_arn       = var.certificate_arn
  public_zone_id        = var.public_zone_id
  public_zone_name      = var.root_public_domain_name
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

resource "aws_ecs_task_definition" "public" {
  family                   = "${var.task_name}-${terraform.workspace}"
  task_role_arn            = aws_iam_role.public_task.arn
  execution_role_arn       = aws_iam_role.public_execution.arn
  cpu                      = var.cpu_reservation
  memory                   = var.memory_reservation
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    module.public_task.task_definition,
    module.public_xray_task.task_definition,
  ])

  tags = {
    Name = "${var.task_name}-${terraform.workspace}"
  }

  depends_on = [
    aws_cloudwatch_log_group.public
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      container_definitions
    ]
  }
}

resource "aws_ecs_service" "public_service" {
  name                               = var.task_name
  cluster                            = var.ecs_cluster.name
  task_definition                    = aws_ecs_task_definition.public.arn
  desired_count                      = var.default_task_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = module.public_alb.target_group.arn
    container_name   = var.task_name
    container_port   = 80
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = concat(var.task_security_group_ids, [module.public_alb.security_group.id])
    assign_public_ip = false
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.public_task.arn
    container_name = var.task_name
  }

  ## these prevent a race condition during deletion
  depends_on = [
    aws_iam_role_policy_attachment.public_execution,
    aws_iam_role_policy_attachment.public_task_xray,
    aws_iam_role_policy_attachment.public_task_application,
  ]

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}
