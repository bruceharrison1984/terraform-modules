resource "random_string" "alb_suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_lb_target_group" "ecs_task" {
  name        = "${var.name_prefix}-${var.service_name}-tg-${random_string.alb_suffix.result}"
  port        = var.target_internal_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  depends_on = [aws_lb.main]

  lifecycle {
    create_before_destroy = true
  }
}
