variable "name_prefix" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_zone_id" {
  description = "The canonical name of the private dns zone"
}

variable "availability_zones" {
  description = "Valid AZs for instances"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets that will be able to access Aurora"
}

variable "cluster_min_capacity" {
  description = "Minimum number of units that the cluster should operate at"
}

variable "cluster_max_capacity" {
  description = "Maximum number of units that the cluster should operate at"
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

variable "kms_key_arn" {
  description = "KMS key used to encrypt the database"
}
