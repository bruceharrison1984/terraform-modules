resource "aws_ecs_task_definition" "ecs_prometheus" {
  family                   = "ecs-prometheus-${terraform.workspace}"
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.execution.arn
  cpu                      = 1024 ## 1 vCPU
  memory                   = 2048 ## 2Gb RAM
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    local.ecs_discovery_task_definition,
    local.ecs_prometheus_task_definition
  ])

  volume {
    name = "ecs-discovery"
  }

  tags = {
    Name = "ecs-prometheus-${terraform.workspace}"
  }

  depends_on = [
    aws_cloudwatch_log_group.ecs_prometheus
  ]
}

locals {
  ##This container scans the ECS cluster to locate containers with the PROMETHEUS_EXPORTER_PORT label
  ecs_discovery_task_definition = {
    name      = "prometheus-ecs-discovery"
    image     = "tkgregory/prometheus-ecs-discovery:latest"
    essential = true
    command = [
      "-config.cluster=${var.ecs_cluster.name}",
      "-config.write-to=/output/ecs_file_sd.yml"
    ]
    mountPoints = [
      {
        sourceVolume  = "ecs-discovery"
        containerPath = "/output"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_prometheus.name
        awslogs-stream-prefix = "prometheus-ecs-discovery"
        awslogs-region        = var.region
      }
    }
  }

  ## This task scrapes logs from containers found by the prometheus-ecs-discovery task
  ecs_prometheus_task_definition = {
    name      = "prometheus"
    image     = "ghcr.io/wingstop-inc/ecomm-prometheus:latest"
    essential = true
    repositoryCredentials = {
      credentialsParameter = var.github_registry_credentials_arn
    }
    portMapping = [
      {
        hostPort      = 9090
        protocol      = "tcp"
        containerPort = 9090
      }
    ]
    environment = [
      {
        name  = "S3_CONFIG_LOCATION"
        value = local.prometheus_config_s3_url
      }
    ]
    mountPoints = [
      {
        sourceVolume  = "ecs-discovery"
        containerPath = "/output"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_prometheus.name
        awslogs-stream-prefix = "prometheus"
        awslogs-region        = var.region
      }
    }
  }
}
