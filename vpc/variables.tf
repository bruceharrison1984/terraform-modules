variable "name_prefix" {
  description = "Prefix added to each resource name"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "default_tags" {
  description = "Tags to be applied to resources"
}

variable "vpc_log_retention_days" {
  description = "How many days to keep VPC logs"
}
