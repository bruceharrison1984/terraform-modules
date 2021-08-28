resource "aws_iam_role" "standalone_execution" {
  name = "${module.standalone_task.task_name}-${terraform.workspace}-execution-role"

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
    Name = "${module.standalone_task.task_name}-${terraform.workspace}-execution-role"
  }
}

resource "aws_iam_role" "standalone_task" {
  name = "${module.standalone_task.task_name}-${terraform.workspace}-task-role"

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
    Name = "${module.standalone_task.task_name}-task-role"
  }
}

resource "aws_iam_role_policy_attachment" "standalone_execution" {
  role       = aws_iam_role.standalone_execution.name
  policy_arn = module.standalone_task.execution_policy_arn
}

resource "aws_iam_role_policy_attachment" "standalone_task" {
  role       = aws_iam_role.standalone_task.name
  policy_arn = module.standalone_task.task_policy_arn
}

resource "aws_iam_role_policy_attachment" "standalone_execution_cwagent" {
  role       = aws_iam_role.standalone_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
