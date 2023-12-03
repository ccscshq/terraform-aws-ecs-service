locals {
  prefix            = "0d1b6a96"
  ipv4_cidr         = "10.0.0.0/16"
  ipv4_cidr_newbits = 3
  subnets_number    = 2
  default_tags = {
    owner      = "ccscshq"
    created_by = "terraform"
  }

  hosted_zone_domain = "example.com"
  ecs_services = {
    main = {
      # acm
      service_domain = "main.${local.hosted_zone_domain}"
      # ecs
      ecs_service_name             = "main"
      ecs_task_cpu                 = 256
      ecs_task_memory              = 512
      ecs_container_image          = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/service_name:0c60a599f7ea1936d8aeeecb868346205d467151"
      ecs_container_port           = 8080
      ecs_desired_count            = 1
      ecs_autoscaling_max_capacity = 2
      ecs_autoscaling_min_capacity = 1
      ecs_environment              = []
      ecs_task_policy_arns         = []
      ecs_cpu_architecture         = "X86_64"
      enable_ecs_exec              = false
      # lb
      lb_healthcheck_interval            = 30
      lb_healthcheck_path                = "/health"
      lb_healthcheck_timeout             = 3
      lb_healthcheck_healthy_threshold   = 2
      lb_healthcheck_unhealthy_threshold = 5
      lb_healthcheck_matcher             = "200-204"
      lb_delete_protection               = false
    }
    sub = {
      # acm
      service_domain = "sub.${local.hosted_zone_domain}"
      # ecs
      ecs_service_name             = "sub"
      ecs_task_cpu                 = 256
      ecs_task_memory              = 512
      ecs_container_image          = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/service_name:0c60a599f7ea1936d8aeeecb868346205d467151"
      ecs_container_port           = 8080
      ecs_desired_count            = 1
      ecs_autoscaling_max_capacity = 2
      ecs_autoscaling_min_capacity = 1
      ecs_environment              = []
      ecs_task_policy_arns         = []
      ecs_cpu_architecture         = "X86_64"
      enable_ecs_exec              = false
      # lb
      lb_healthcheck_interval            = 30
      lb_healthcheck_path                = "/health"
      lb_healthcheck_timeout             = 3
      lb_healthcheck_healthy_threshold   = 2
      lb_healthcheck_unhealthy_threshold = 5
      lb_healthcheck_matcher             = "200-204"
      lb_delete_protection               = false
    }
  }
}
