variable "name_prefix" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_zone_id" {
  description = "The canonical name of the private dns zone"
}

variable "private_subnet_ids" {
  description = "Subnet to deploy RabbitMQ into"
  type        = list(string)
}

variable "instance_size" {
  description = "The size of the RabbitMQ instances (this value is constrained to certain sizes)"
}

variable "timeout" {
  description = "Amount of time to wait before failing the CloudFormation deployment"
  default     = 20
}

variable "cloudmap_private_dns_id" {
  description = "The ARN of the Service Discovery service that all containers should be assoicated with"
}

variable "desired_username_ssm_parameter_name" {
  description = "This value of this SSM parameter will be set as the db-admin username"
}

variable "desired_password_ssm_parameter_name" {
  description = "This value of this SSM parameter will be set as the db-admin password"
}