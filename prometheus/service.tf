
resource "aws_ecs_service" "ecs-prometheus" {
  name                               = "ecs-prometheus"
  cluster                            = var.ecs_cluster.name
  task_definition                    = aws_ecs_task_definition.ecs_prometheus.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets         = var.private_subnets
    security_groups = concat(var.task_security_group_ids, [aws_security_group.prometheus_traffic.id])
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.prometheus.arn
    container_name = "prometheus-${terraform.workspace}"
  }

  depends_on = [
    aws_s3_bucket_object.prometheus_config
  ]
}
