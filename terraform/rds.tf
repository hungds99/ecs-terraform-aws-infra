resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-${var.environment}-main-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags       = { Name = "${var.app_name}-${var.environment}-main-db-subnet-group" }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.app_name}-${var.environment}-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp2"
  username               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string)["username"]
  password               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string)["password"]
  db_name                = "${var.app_name}-${var.environment}-db"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
}
