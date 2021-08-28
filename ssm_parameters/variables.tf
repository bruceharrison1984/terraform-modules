variable "parameters" {
  description = "A Key/Value map of values that will be added to SSM Parameter Store"
  type        = map(string)
}

variable "prefix" {
  description = "Prefix that will be applied to the SSM Parameter name"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the SSM parameter"
  type        = string
}

variable "overwrite" {
  description = "If the value changes, should Terraform put the original value back?"
  type        = bool
  default     = true
}
