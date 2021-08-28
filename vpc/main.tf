resource "aws_vpc" "main" {
  cidr_block           = var.cidr_range
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }

  depends_on = [aws_cloudwatch_log_group.vpc_flow_log]
}

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-vpc-flow-log"
  }
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "${var.name_prefix}-vpc-flow-log"
  retention_in_days = var.vpc_log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = {
    Name = "${var.name_prefix}-vpc-flow-log"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  available_azs = slice(data.aws_availability_zones.available.names, 0, var.az_limit <= 0 ? 1 : min(var.az_limit, length(data.aws_availability_zones.available)))
  number_of_azs = length(local.available_azs)
}
