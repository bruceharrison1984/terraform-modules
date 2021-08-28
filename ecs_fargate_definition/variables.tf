variable "task_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "entry_point" {
  type    = list(string)
  default = null
}

variable "container_tag" {
  type    = string
  default = "latest"
}

variable "log_group" {
  type    = string
  default = null
}

variable "log_stream_prefix" {
  type    = string
  default = null
}

variable "port_mappings" {
  type = list(object({
    protocol      = string
    containerPort = number
    hostPort      = number
  }))
  default = null
}

variable "secrets" {
  type    = map(string)
  default = {}
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "essential" {
  type    = bool
  default = true
}

variable "docker_labels" {
  description = "These labels will be applied to the task definition container as Docker labels"
  type        = map(string)
  default     = {}
}

variable "repository_credentials" {
  type    = string
  default = null
}

variable "kms_key_arn" {
  default = "ARN of KMS key to use for decryption of SSM parameters"
  type    = string
}

variable "ssm_parameter_root_arn" {
  default = null
  type    = string
}
