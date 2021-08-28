data "aws_ssm_parameter" "db_administrator_username" {
  name = var.desired_username_ssm_parameter_name
}

data "aws_ssm_parameter" "db_administrator_password" {
  name = var.desired_password_ssm_parameter_name
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier           = "${var.name_prefix}-postgres-aurora"
  engine_mode                  = "serverless"
  engine                       = "aurora-postgresql"
  availability_zones           = var.availability_zones
  master_username              = data.aws_ssm_parameter.db_administrator_username.value
  master_password              = data.aws_ssm_parameter.db_administrator_password.value
  backup_retention_period      = 7
  preferred_backup_window      = "06:00-07:00"         //12-1am CST
  preferred_maintenance_window = "mon:08:00-mon:09:00" //monday 1am-2am CST
  apply_immediately            = true
  db_subnet_group_name         = aws_db_subnet_group.main.name
  skip_final_snapshot          = true
  vpc_security_group_ids       = [aws_security_group.aurora.id]
  port                         = 5432
  storage_encrypted            = true
  kms_key_id                   = var.kms_key_arn

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 8
    min_capacity             = 2
    seconds_until_auto_pause = 14400 ## 4 hours
  }

  tags = {
    Name = "${var.name_prefix}-postgres-aurora"
  }

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-postgres-aurora-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.name_prefix}-postgres-aurora-subnet-group"
  }
}
