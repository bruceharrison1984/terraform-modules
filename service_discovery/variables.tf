variable "vpc_id" {
  description = "ARN of the VPC to deploy DNS into"
  type        = string
}

variable "name_prefix" {
  type = string
}

variable "private_zone_name" {
  description = "The fqdn of the private DNS zone"
}

variable "public_zone_name" {
  description = "The fqdn of the public DNS zone"
}
