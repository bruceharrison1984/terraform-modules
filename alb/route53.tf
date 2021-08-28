resource "aws_route53_record" "alb" {
  zone_id = var.public_zone_id
  name    = "${var.service_name}.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "1"
  records = [aws_lb.main.dns_name]
}
