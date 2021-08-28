resource "aws_s3_bucket" "prometheus_config" {
  bucket = "${var.name_prefix}-ecs-prometheus"
  acl    = "private"
}

locals {
  prometheus_config        = <<EOF
global:
  evaluation_interval: 1m
  scrape_interval: 30s
  scrape_timeout: 10s
remote_write:
  - url: ${aws_prometheus_workspace.ecs.prometheus_endpoint}api/v1/remote_write
    sigv4:
      region: ${var.region}
scrape_configs:
  - job_name: ecs
    file_sd_configs:
      - files:
          - /output/ecs_file_sd.yml
        refresh_interval: 1m
EOF
  prometheus_config_s3_url = "s3://${aws_s3_bucket.prometheus_config.id}/${aws_s3_bucket_object.prometheus_config.key}"
}

resource "aws_s3_bucket_object" "prometheus_config" {
  bucket  = aws_s3_bucket.prometheus_config.id
  key     = "prometheus.yml"
  content = local.prometheus_config
  etag    = md5(local.prometheus_config)
}
