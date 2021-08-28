resource "aws_security_group" "rabbit_mq" {
  name   = "${var.name_prefix}-sg-rabbitmq"
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 5671
    to_port   = 5671
    self      = true
  }

  egress {
    protocol  = "tcp"
    from_port = 5671
    to_port   = 5671
    self      = true
  }

  //allow access to the web UI
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    self      = true
  }

  tags = {
    Name = "${var.name_prefix}-sg-rabbitmq"
  }
}
