variable "cloudmap_private_dns_id" {
  description = "The ARN of the Service Discovery service that all containers should be assoicated with"
}

variable "name_prefix" {
  description = "The name of the task that will be applied to resources"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "region" {
  description = "The region that logs should appear in"
}

variable "ecs_cluster" {
  description = "The ID of the ECS cluster where containers will be deployed"
}

variable "private_subnets" {
  description = "Private subnets where containers will be deployed"
}

variable "task_security_group_ids" {
  type        = list(string)
  description = "Security groups that will be applied to the ECS task (Aurora, RabbitMQ, etc)"
}


variable "environment_variables" {
  description = "Environment Variables to pass to containers"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  type = string
}

variable "cloudwatch_retention_period" {
  type = number
}

variable "cpu_reservation" {
  type = number
}

variable "memory_reservation" {
  type = number
}

variable "github_registry_credentials_arn" {
  type = string
}
