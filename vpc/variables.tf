variable "az_limit" {
  description = "Maximum number of AZs to allocate to the VPC"
  type        = number
}

variable "cidr_range" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt VPC logs"
  type        = string
}

variable "vpc_log_retention_days" {
  type = number
}
