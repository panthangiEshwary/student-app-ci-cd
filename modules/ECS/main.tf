resource "aws_ecs_cluster" "student_app_cluster" {
  name = "student-app-cluster"

  tags = {
    Name = "student-app-cluster"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "student-app-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "student-app-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs_app_logs" {
  name              = "/ecs/student-app"
  retention_in_days = 7

  tags = {
    Name = "student-app-ecs-logs"
  }
}

resource "aws_ecs_task_definition" "student_app_task" {
  family                   = "student-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "student-app-container"
    image = "${var.ecr_repository_url}:latest"
    cpu       = 256
    memory    = 512
    essential = true

    portMappings = [{
      containerPort = 8000
      protocol      = "tcp"
    }]

    environment = [
      { name = "DB_HOST",     value = var.db_endpoint },
      { name = "DB_USER",     value = var.db_master_username },
      { name = "DB_PASSWORD", value = var.db_master_password },
      { name = "DB_NAME",     value = var.db_name }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_app_logs.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  tags = {
    Name = "student-app-task"
  }
}

resource "aws_ecs_service" "student_app_service" {
  name            = "student-app-service"
  cluster         = aws_ecs_cluster.student_app_cluster.id
  task_definition = aws_ecs_task_definition.student_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_fargate_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "student-app-container"
    container_port   = 8000
  }

  depends_on = [aws_ecs_task_definition.student_app_task]

  tags = {
    Name = "student-app-service"
  }
}
