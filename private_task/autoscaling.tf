resource "aws_appautoscaling_target" "private" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.name}/${aws_ecs_service.private_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

//this controls when scaling occurs due to memory constraints
resource "aws_appautoscaling_policy" "private_memory" {
  name               = "${var.task_name}-${terraform.workspace}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.private.resource_id
  scalable_dimension = aws_appautoscaling_target.private.scalable_dimension
  service_namespace  = aws_appautoscaling_target.private.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80

    scale_in_cooldown  = 300
    scale_out_cooldown = 30
  }
}

//this controls when scaling occurs due to cpu constraints
resource "aws_appautoscaling_policy" "private_cpu" {
  name               = "${var.task_name}-${terraform.workspace}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.private.resource_id
  scalable_dimension = aws_appautoscaling_target.private.scalable_dimension
  service_namespace  = aws_appautoscaling_target.private.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 75

    scale_in_cooldown  = 300
    scale_out_cooldown = 30
  }
}
