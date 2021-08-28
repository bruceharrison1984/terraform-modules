variable "allowed_ingress_cidrs" {
  description = "IP CIDRs that are allowed to hit the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "certificate_arn" {
  description = "The ARN of the certificate that will be used for TLS"
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}

variable "name_prefix" {
  description = "The prefix that will be applied to resource names"
}

variable "public_zone_name" {
  description = "Public DNS zone name"
}

variable "public_zone_id" {
  description = "Public DNS zone id"
}

variable "service_name" {
  description = "The name of the service that this ALB will be in front of. This affects the final url"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Comma separated list of subnet IDs"
}

variable "target_internal_port" {
  description = "The internal port on the target group that requests will be redirected to"
}

variable "vpc_id" {
  description = "VPC ID"
}
