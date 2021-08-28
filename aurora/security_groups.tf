resource "aws_security_group" "aurora" {
  name   = "${var.name_prefix}-sg-aurora"
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432
    self      = true
  }

  egress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432
    self      = true
  }

  tags = {
    Name = "${var.name_prefix}-sg-aurora"
  }
}
