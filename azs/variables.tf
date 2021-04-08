variable "instance_type_filter" {
  description = "Only allow AZs that can launch the specified instance types"
  type        = list(string)
  default     = ["*"] // * matches all instance types
}

variable "az_state_filter" {
  description = "Filter out AZs if they don't meet a certain state"
  default     = "available"
}

variable "az_limit" {
  description = "Trim the number of possible AZs down to this number"
  default     = 0
}
