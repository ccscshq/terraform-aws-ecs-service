resource "aws_ecs_task_definition" "this" {
  family                   = "${var.prefix}-${var.ecs_service_name}"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.task_execution.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.ecs_cpu_architecture
  }

  container_definitions = jsonencode([
    {
      "name" : "backend",
      "image" : var.ecs_container_image,
      "cpu" : 0,
      "memory" : 512,
      "essential" : true,
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : var.ecs_container_port,
        }
      ],
      "environment" : var.ecs_environment,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : var.ecs_cloudwatch_log_group_name,
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "${var.ecs_service_name}"
        }
      },
      "linuxParameters" : {
        "initProcessEnabled" : true
      },
    }
  ])
}

resource "aws_ecs_service" "this" {
  name                   = var.ecs_service_name
  cluster                = var.ecs_cluster_id
  task_definition        = aws_ecs_task_definition.this.arn
  desired_count          = var.ecs_desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = var.enable_ecs_exec

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "backend"
    container_port   = var.ecs_container_port
  }

  propagate_tags = "TASK_DEFINITION"

  lifecycle {
    ignore_changes = [desired_count]
  }
}
