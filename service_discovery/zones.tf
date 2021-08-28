resource "aws_route53_zone" "public" {
  name = var.public_zone_name

  tags = {
    Name = var.public_zone_name
  }
}


resource "aws_service_discovery_private_dns_namespace" "private" {
  name        = var.private_zone_name
  description = "Internal DNS Zone for ${terraform.workspace} workspace"
  vpc         = var.vpc_id

  tags = {
    Name = var.private_zone_name
  }
}
