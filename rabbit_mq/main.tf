data "aws_ssm_parameter" "rabbit_administrator_username" {
  name = var.desired_username_ssm_parameter_name
}

data "aws_ssm_parameter" "rabbit_administrator_password" {
  name = var.desired_password_ssm_parameter_name
}

resource "aws_cloudformation_stack" "rabbit_mq" {
  name               = "${var.name_prefix}-rabbitmq-stack"
  timeout_in_minutes = var.timeout

  parameters = {
    ClusterName    = "${var.name_prefix}-rabbitmq"
    Subnets        = join(",", var.private_subnet_ids)
    SecurityGroups = aws_security_group.rabbit_mq.id
    AdminUsername  = data.aws_ssm_parameter.rabbit_administrator_username.value
    AdminPassword  = data.aws_ssm_parameter.rabbit_administrator_password.value
    InstanceSize   = var.instance_size
  }

  template_body = file("${path.module}/cloudformation/rabbitmq.yml")

  ## these tags are also applied to the infrastructure created by cloudformation
  tags = {
    Name           = "${var.name_prefix}-rabbitmq"
    cloudformation = true
  }

  lifecycle {
    ignore_changes = [parameters, template_body, timeout_in_minutes, tags] ## rabbitmq cannot be changed after deployment
  }
}

locals {
  ## Extract hostname from connection string so we can create a nice CNAME record
  hostname = regex("amqps:\\/\\/(.*):\\d*", aws_cloudformation_stack.rabbit_mq.outputs["AmqpEndpoints"])[0]
}
