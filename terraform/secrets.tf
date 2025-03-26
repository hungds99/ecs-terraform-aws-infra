resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.app_name}-${var.environment}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = var.db_password
  })
}
