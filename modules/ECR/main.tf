resource "aws_ecr_repository" "student_app_repo" {
  name                 = "student-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "student-app-repo"
  }
}

