locals {
  azs = keys({ for az, details in data.aws_ec2_instance_type_offerings.available : az => details.instance_types if length(details.instance_types) > 0 })
}

output "all" {
  value = keys(data.aws_ec2_instance_type_offerings.available)
}

output "filtered" {
  value = local.azs
}

//if az_limit lt/eq to 0, return single AZ. Otherwise return the smaller number of az_limit and total azs to prevent over-indexing
output "filtered_limited" {
  value = slice(
    local.azs,
    0,
    var.az_limit <= 0 ? 1 : min(var.az_limit, length(local.azs))
  )
}
