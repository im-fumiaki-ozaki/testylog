# ---------------------------------------------
# SSM Parameter Store
# ---------------------------------------------
resource "aws_ssm_parameter" "host" {
  name  = "/im-ozaki/${var.project}/${var.environment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}

resource "aws_ssm_parameter" "port" {
  name  = "/im-ozaki/${var.project}/${var.environment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
  # value = "3306"
}

resource "aws_ssm_parameter" "database" {
  name  = "/im-ozaki/${var.project}/${var.environment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.name
  # value = "tastylog"
}

resource "aws_ssm_parameter" "username" {
  name  = "/im-ozaki/${var.project}/${var.environment}/app/MYSQL_USERNAME"
  type  = "SecureString"
  value = var.username
}

resource "aws_ssm_parameter" "password" {
  name  = "/im-ozaki/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
  type  = "SecureString"
  value = var.password
}

