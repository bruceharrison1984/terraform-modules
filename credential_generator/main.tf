variable "username_length" {
  type    = number
  default = 24
}

variable "username_options" {
  type = object({
    upper   = bool
    number  = bool
    special = bool
  })
  default = {
    number  = false
    special = false
    upper   = false
  }
}

variable "password_options" {
  type = object({
    upper            = bool
    number           = bool
    special          = bool
    override_special = string
  })
  default = {
    number           = true
    special          = true
    upper            = true
    override_special = "!#?"
  }
}

variable "password_length" {
  type    = number
  default = 24
}

resource "random_password" "username" {
  length      = var.username_length
  min_lower   = 1
  min_upper   = var.username_options.upper ? 1 : 0
  min_numeric = var.username_options.number ? 1 : 0
  min_special = var.username_options.special ? 1 : 0
  upper       = var.username_options.upper
  number      = var.username_options.number
  special     = var.username_options.special
}

resource "random_password" "password" {
  length           = var.password_length
  min_lower        = 1
  min_upper        = var.password_options.upper ? 1 : 0
  min_numeric      = var.password_options.number ? 1 : 0
  min_special      = var.password_options.special ? 1 : 0
  upper            = var.password_options.upper
  number           = var.password_options.number
  special          = var.password_options.special
  override_special = var.password_options.override_special
}

output "username" {
  value     = random_password.username.result
  sensitive = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}
