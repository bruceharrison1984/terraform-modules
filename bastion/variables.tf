variable "base_name" {
  description = "Prefix placed on to resource names"
}

variable "default_tags" {
  description = "Tags to be applied to resources"
}

variable "vpc_id" {
  description = "VPC to deploy instance in to"
}

variable "public_subnet_id" {
  description = "Public subnet to deploy instance in to"
}

variable "security_group_ids" {
  description = "Security groups to allow access into AWS resources"
  type        = list(string)
}

variable "ip_whitelist" {
  type        = list(string)
  description = "IP addresses who have access to SSH in to the server"
}

variable "instance_size" {
  description = "EC2 instance size to be created"
}
