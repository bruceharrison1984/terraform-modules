data "aws_availability_zones" "available" {
  state = var.az_state_filter
}

//we filter the list to only include AZs that allow deployment of RabbitMQ mq.m5.large instances
data "aws_ec2_instance_type_offerings" "available" {
  for_each = toset(data.aws_availability_zones.available.names)

  filter {
    name   = "instance-type"
    values = var.instance_type_filter
  }

  filter {
    name   = "location"
    values = [each.value]
  }

  location_type = "availability-zone"
}


