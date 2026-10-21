# ---------------------------------------------
# Security Group
# ---------------------------------------------
# web security group
resource "aws_security_group" "web_sg" {
  name        = "im-ozaki-${var.environment}-web-sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "im-ozaki-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  prefix_list_ids   = ["pl-0b5aa6930fb9f7995"]
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = ["pl-0b5aa6930fb9f7995"]
}

resource "aws_security_group_rule" "web_out_tcp3000" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.app_sg.id
}

# app security group
resource "aws_security_group" "app_sg" {
  name        = "im-ozaki-${var.environment}-app-sg"
  description = "application server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "im-ozaki-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "app_in_tcp3000" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.web_sg.id
}

# resource "aws_security_group_rule" "app_out_http" {
#   security_group_id = aws_security_group.app_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
# }

# resource "aws_security_group_rule" "app_out_https" {
#   security_group_id = aws_security_group.app_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
# }

resource "aws_security_group_rule" "app_out_tcp3306" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db_sg.id
}

# opmng security group
resource "aws_security_group" "opmng_sg" {
  name        = "im-ozaki-${var.environment}-opmng-sg"
  description = "operation and management role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "im-ozaki-${var.environment}-opmng-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "opmng_in_ssh" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  prefix_list_ids   = ["pl-0b5aa6930fb9f7995"]
}

resource "aws_security_group_rule" "opmng_in_tcp3000" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  prefix_list_ids   = ["pl-0b5aa6930fb9f7995"]
}

resource "aws_security_group_rule" "opmng_out_http" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_https" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "im-ozaki-${var.environment}-db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.app_sg.id]
  }

  tags = {
    Name    = "im-ozaki-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}
