resource "aws_security_group" "prometheus_traffic" {
  name        = "${var.name_prefix}-ecs-prometheus"
  description = "Allow access to the built-in Prometheus console"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-ecs-prometheus"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "console_traffic" {
  security_group_id = aws_security_group.prometheus_traffic.id
  description       = "Allow inbound access to the prometheus console"

  type      = "ingress"
  from_port = 9090
  to_port   = 9090
  protocol  = "tcp"
  self      = true
}
