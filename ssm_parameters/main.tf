resource "aws_ssm_parameter" "config" {
  for_each = var.parameters

  name      = "/${join("/", var.prefix != null ? [terraform.workspace, var.prefix, each.key] : [terraform.workspace, each.key])}"
  type      = "SecureString"
  value     = var.parameters[each.key]
  tier      = "Standard"
  overwrite = var.overwrite
  data_type = "text"
  key_id    = var.kms_key_arn
  tags = {
    Name = "/${join("/", var.prefix != null ? [terraform.workspace, var.prefix, each.key] : [terraform.workspace, each.key])}"
  }
}
