resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.base_name}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role" "bastion_role" {
  name = "${var.base_name}-bastion-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(var.default_tags, {
    Name = "${var.base_name}-bastion-instance-role"
  })
}
