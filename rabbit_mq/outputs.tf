output "security_group" {
  value = aws_security_group.rabbit_mq
}

output "rabbitmq_fqdns"{
  value = aws_cloudformation_stack.rabbit_mq.outputs["AmqpEndpoints"]
}