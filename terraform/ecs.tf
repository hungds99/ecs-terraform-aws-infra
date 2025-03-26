resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}--ecs-cluster"
  tags = { Name = "${var.app_name}-${var.environment}--ecs-cluster" }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.environment}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.app_name}-${var.environment}-container"
    image = var.container_image
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
    secrets = [{
      name      = "DB_CREDENTIALS"
      valueFrom = aws_secretsmanager_secret.db_credentials.arn
    }]
    environment = [
      { name = "DB_HOST", value = aws_db_instance.main.address },
      { name = "DB_PORT", value = "3306" },
      { name = "DB_NAME", value = "mydb" },
      { name = "WEBAPP_URL", value = var.webapp_url },
      { name = "NEXTAUTH_URL", value = var.nextauth_url },
      { name = "ENCRYPTION_KEY", value = var.encryption_key },
      { name = "NEXTAUTH_SECRET", value = var.nextauth_secret },
      { name = "CRON_SECRET", value = var.cron_secret },
    ]
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.app_name}-${var.environment}"
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = 30
}

resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.ecs_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.app_name}-${var.environment}-container"
    container_port   = 80
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy, aws_lb_listener.http]
}
