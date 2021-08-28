resource "aws_kms_key" "kms" {
  description             = "Default encryption key for WRI"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.kms.json

  tags = {
    Name = "${var.name_prefix}-kms-key"
  }
}
