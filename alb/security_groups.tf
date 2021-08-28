resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-${var.service_name}-alb"
  description = "Security group for the ${var.name_prefix}-${var.service_name}-alb load balancer"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-${var.service_name}-alb"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "external_inbound_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow inbound HTTP"
  type              = "ingress"
  cidr_blocks       = var.allowed_ingress_cidrs
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_security_group_rule" "external_inbound_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow inbound HTTPS"
  type              = "ingress"
  cidr_blocks       = var.allowed_ingress_cidrs
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_security_group_rule" "internal_inbound_http" {
  security_group_id = aws_security_group.alb.id
  protocol          = "tcp"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  self              = true
  description       = "Allow internal inbound HTTP"
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  description       = "Allow egress"
}
