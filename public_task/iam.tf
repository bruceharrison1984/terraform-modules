resource "aws_iam_role" "public_execution" {
  name = "${module.public_task.task_name}-${terraform.workspace}-execution-role"

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
    Name = "${module.public_task.task_name}-${terraform.workspace}-execution-role"
  }
}

resource "aws_iam_role" "public_task" {
  name = "${module.public_task.task_name}-${terraform.workspace}-task-role"

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
    Name = "${module.public_task.task_name}-task-role"
  }
}

resource "aws_iam_role_policy_attachment" "public_execution" {
  role       = aws_iam_role.public_execution.name
  policy_arn = module.public_task.execution_policy_arn
}

resource "aws_iam_role_policy_attachment" "private_execution_cwagent" {
  role       = aws_iam_role.public_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "public_task_application" {
  role       = aws_iam_role.public_task.name
  policy_arn = module.public_task.task_policy_arn
}

resource "aws_iam_role_policy_attachment" "public_task_xray" {
  role       = aws_iam_role.public_task.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
