resource "aws_iam_role" "execution" {
  name = "ecs-prometheus-${terraform.workspace}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "ecs-prometheus-${terraform.workspace}-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "execution_cwagent_execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name        = "ecs-prometheus-${terraform.workspace}-repository-credentials-policy"
  description = "Allow IAM access to the AWS Secret Manager secret that has credentials for a private docker registry"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": ${jsonencode(var.github_registry_credentials_arn)}
    }
  ]
}
EOF

  tags = {
    Name = "ecs-prometheus-${terraform.workspace}-repository-credentials-policy"
  }
}
