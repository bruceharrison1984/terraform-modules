resource "aws_prometheus_workspace" "ecs" {
  alias = "${var.name_prefix}-prometheus"
}
