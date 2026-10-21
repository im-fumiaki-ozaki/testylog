# ---------------------------------------------
# Elastic Container Registry
# ---------------------------------------------
resource "aws_ecr_repository" "webapp" {
  name                 = "im-ozaki-${var.project}-webapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = "im-ozaki-${var.project}-webapp"
    Project = var.project
  }

  # force_delete = true
}
