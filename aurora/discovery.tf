resource "aws_service_discovery_service" "aurora" {
  name = "aurora"

  dns_config {
    namespace_id = var.cloudmap_private_dns_id

    dns_records {
      ttl  = 10
      type = "CNAME"
    }

    routing_policy = "WEIGHTED"
  }

  tags = {
    Name = "aurora"
  }
}

// We have to use CF because a resource doesn't yet exist to create Cloud Map Instance registrations
// https://github.com/hashicorp/terraform-provider-aws/issues/8568
resource "aws_cloudformation_stack" "aurora_dns_alias" {
  name = "aurora-cloudmap-dns-alias-${terraform.workspace}"
  parameters = {
    InstanceCName = aws_rds_cluster.postgresql.endpoint
    ServiceId     = aws_service_discovery_service.aurora.id
  }
  template_body = <<EOF
Parameters:
  InstanceCName:
    Type: String
    Description: CNAME of the resource to be mapped
  ServiceId:
    Type: String
    Description: The ServiceID of the Discover Service entry to assoicate with the CName
Resources:
  AuroraServiceDiscoverAlias:
    Type: AWS::ServiceDiscovery::Instance
    Properties:
      InstanceAttributes:
        AWS_INSTANCE_CNAME: !Ref InstanceCName
      ServiceId: !Ref ServiceId
  EOF
}
