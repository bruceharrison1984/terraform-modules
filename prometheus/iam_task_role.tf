

resource "aws_iam_role" "task" {
  name = "ecs-prometheus-${terraform.workspace}-task-role"

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
    Name = "ecs-prometheus-task-role"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_prometheus" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.cloudwatch_prometheus.arn
}

resource "aws_iam_policy" "cloudwatch_prometheus" {
  name        = "${terraform.workspace}-ecs-prometheus"
  description = "This policy is used by the tkgregory/prometheus-ecs-discovery container to identify ECS tasks that have Prometheus endpoints"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:List*",
          "ecs:Describe*",
        ]
        Resource = [
          var.ecs_cluster.arn,                                     ## scanning cluster
          "${replace(var.ecs_cluster.arn, ":cluster", ":task")}/*" ## scanning cluster tasks
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:ListTasks",
          "ecs:DescribeTaskDefinition",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.prometheus_config.arn,
          "${aws_s3_bucket.prometheus_config.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "aps:RemoteWrite",
        ]
        Resource = aws_prometheus_workspace.ecs.arn
      }
    ]
  })

  tags = {
    Name = "${terraform.workspace}-ecs-prometheus"
  }
}
