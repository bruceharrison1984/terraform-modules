variable "task_name" {
  description = "Name of the task to be run"
}

variable "container" {
  description = "The container to run"
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
}

variable "environment_variables" {
  description = "Environment Variables to pass to containers"
  type        = map(string)
}

variable "kms_key_arn" {}

variable "ssm_parameter_root_arn" {
  default = null
  type    = string
}
