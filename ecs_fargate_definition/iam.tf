locals {
  secret_arns = compact([var.kms_key_arn, var.ssm_parameter_root_arn])
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name        = "${terraform.workspace}-${var.task_name}-repository-credentials-policy"
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
      "Resource": ${jsonencode(var.repository_credentials)}
    }
  ]
}
EOF

  tags = {
    Name = "${terraform.workspace}-${var.task_name}-repository-credentials-policy"
  }
}


resource "aws_iam_policy" "ecs_task_policy" {
  name = "${terraform.workspace}-${var.task_name}-ecs-task-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  %{if length(local.secret_arns) > 0}
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "kms:Decrypt"
      ],
      "Resource": ${jsonencode(local.secret_arns)}
    }
  %{endif}
  ]
}
EOF

  tags = {
    Name = "${terraform.workspace}-${var.task_name}-ecs-task-policy"
  }
}
