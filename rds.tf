data "aws_secretsmanager_secret" "metabase_db_credentials" {
  name = var.metabase_db_credentials_secret_name
}

data "aws_secretsmanager_secret_version" "metabase_current" {
  secret_id = data.aws_secretsmanager_secret.metabase_db_credentials.id
}

resource "aws_db_subnet_group" "metabase_subnet_group" {
  name       = "metabase_${var.environment}_db_subnet_group"
  subnet_ids = var.private_subnet_ids
  tags       = merge(var.default_tags, var.tags)
}

resource "aws_db_instance" "metabase_db" {
  identifier        = "metabase-${var.environment}-application-backend-db"
  allocated_storage = var.db_allocated_storage
  instance_class    = var.db_instance_type

  engine                 = "mysql"
  engine_version         = "8.0"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.metabase_subnet_group.id
  vpc_security_group_ids = [aws_security_group.metabase_rds_sg.id]

  db_name  = "metabase"
  username = "metabase"
  password = jsondecode(data.aws_secretsmanager_secret_version.metabase_current.secret_string)["password"]

  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window
  maintenance_window      = var.rds_maintenance_window

  publicly_accessible         = false
  copy_tags_to_snapshot       = true
  deletion_protection         = true
  storage_encrypted           = true
  allow_major_version_upgrade = true

  apply_immediately = true

  tags = merge(var.default_tags, var.tags)
}
