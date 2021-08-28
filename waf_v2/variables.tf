variable "name_prefix" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "alb_arns" {
  description = "ARNs of the ALBs to attach the WAF to"
  type        = list(string)
}

variable "enable_cloudwatch_metrics" {
  description = "Should metrics be sent to cloudwatch"
  default     = false
}

variable "enable_sampling_requests" {
  description = "Should requests be sampled"
  default     = false
}

variable "ip_rate_limit" {
  description = "Requests will be dropped if this number is exceed within a 5 minute window"
  default     = 1000
}
