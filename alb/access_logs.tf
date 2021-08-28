resource "aws_s3_bucket" "alb_logs" {
  bucket        = "${var.name_prefix}-${var.service_name}-access-logs"
  acl           = "private"
  force_destroy = true

  lifecycle_rule {
    id      = "transition-to-deep-archive"
    enabled = true
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = {
    Name = "${var.name_prefix}-${var.service_name}-access-logs"
  }
}
resource "aws_s3_bucket_public_access_block" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true

  depends_on = [aws_s3_bucket_policy.alb_logs] //make sure policies are applied before enabling
}

data "aws_elb_service_account" "alb_logs" {}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = data.aws_iam_policy_document.alb_logs.json
}


data "aws_iam_policy_document" "alb_logs" {
  version   = "2012-10-17"
  policy_id = "${var.name_prefix}-${var.service_name}-access-logs-policy"

  statement {
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.alb_logs.arn}/*"]
    principals {
      identifiers = ["${data.aws_elb_service_account.alb_logs.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.alb_logs.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.alb_logs.arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
