resource "random_id" "db_subnet_group_suffix" {
  byte_length = 4
}

resource "aws_db_subnet_group" "students_db_subnet_group" {
  name       = "students-db-subnet-group-${random_id.db_subnet_group_suffix.hex}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "students-db-subnet-group"
  }
}

resource "random_id" "db_instance_suffix" {
  byte_length = 4
}

resource "aws_db_instance" "students_db" {
  identifier             = "students-db-${random_id.db_instance_suffix.hex}"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "students"
  username               = var.db_master_username
  password               = var.db_master_password
  skip_final_snapshot    = true
  multi_az               = false
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.students_db_subnet_group.name
  publicly_accessible    = false

  tags = {
    Name = "students-db"
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "student_app/${aws_db_instance.students_db.identifier}_secrets"
  description = "Database credentials for the student application"

  tags = {
    Name = "StudentAppDBCredentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = var.db_master_password
    engine   = "mysql"
    host     = aws_db_instance.students_db.address
    port     = aws_db_instance.students_db.port
    dbname   = aws_db_instance.students_db.db_name
  })
}