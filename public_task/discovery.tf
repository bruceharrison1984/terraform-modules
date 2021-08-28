resource "aws_service_discovery_service" "public_task" {
  name = module.public_task.task_name

  dns_config {
    namespace_id = var.cloudmap_private_dns_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    Name = module.public_task.task_name
  }
}
