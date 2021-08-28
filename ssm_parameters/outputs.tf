## This output is consumed downstream by the rest of the infrastructure
## It produces a truncated k/v map so you can reference parameters without the environment name and leading slash
## example:
## "api/demouiaccount/password" = "/alpha/api/demouiaccount/password"
## "api/demouiaccount/username" = "/alpha/api/demouiaccount/username"
## "api/rabbitmq/connectionsettings/enablessl" = "/alpha/api/rabbitmq/connectionsettings/enablessl"
output "ids" {
  value = zipmap(
    [for s in keys(aws_ssm_parameter.config) : var.prefix != null ? join("/", [var.prefix, s]) : s],
    [for v in values(aws_ssm_parameter.config) : { fullname = v.name, arn = v.arn }]
  )
}

locals {
  root_arn_name = var.prefix != null ? var.prefix : keys(aws_ssm_parameter.config)[0]
  root_arn = tomap({
    (local.root_arn_name) = trimsuffix(regex("(^\\S*:(\\w*\\/){3})", values(aws_ssm_parameter.config)[0].arn)[0], "/")
  })
}

output "root_arn" {
  value = local.root_arn
}
