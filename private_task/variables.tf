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

variable "github_registry_credentials_arn" {
  description = "The ARN of the AWS Secret that contains the credentials to login to Github Container Registry"
}

variable "secrets" {
  description = "AWS Secret Manager secrets that the task needs access to"
  type        = map(string)
  default     = {}
}

variable "environment_variables" {
  description = "Environment Variables to pass to containers"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {}

variable "default_task_count" {
  description = "How many duplicate tasks should be run under each service"
  default     = 1
}

variable "cloudmap_private_dns_id" {
  description = "The ARN of the Service Discovery service that all containers should be assoicated with"
}

variable "task_name" {
  description = "The name that will appear in ECS"
}

variable "container" {
  description = "The primary container that the task should run"
}

variable "ssm_parameter_root_arn" {
  default = null
  type    = string
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

variable "create_xray_task" {
  type    = bool
  default = true
}

variable "docker_labels" {
  description = "These labels will be applied to the task definition container as Docker labels"
  type        = map(string)
  default     = {}
}
