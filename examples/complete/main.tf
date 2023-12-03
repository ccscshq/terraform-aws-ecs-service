module "network" {
  source = "git@github.com:ccscshq/terraform-aws-network.git?ref=v0.1.0"

  prefix                 = local.prefix
  ipv4_cidr              = local.ipv4_cidr
  ipv4_cidr_newbits      = local.ipv4_cidr_newbits
  subnets_number         = local.subnets_number
  create_private_subnets = true
}

module "ecs_cluster" {
  source = "git@github.com:ccscshq/terraform-aws-ecs-cluster.git?ref=v0.2.0"

  ecs_cluster_name            = "86f13341"
  create_cloudwatch_log_group = true
}

module "ecs_service" {
  for_each = local.ecs_services

  source = "../.."

  prefix = local.prefix
  # acm
  hosted_zone_domain = local.hosted_zone_domain
  service_domain     = each.value.service_domain
  # ecs
  ecs_cluster_id                = module.ecs_cluster.ecs_cluster_id
  ecs_cluster_name              = module.ecs_cluster.ecs_cluster_name
  ecs_service_name              = each.value.ecs_service_name
  ecs_task_cpu                  = each.value.ecs_task_cpu
  ecs_task_memory               = each.value.ecs_task_memory
  ecs_container_image           = each.value.ecs_container_image
  ecs_container_port            = each.value.ecs_container_port
  ecs_desired_count             = each.value.ecs_desired_count
  ecs_autoscaling_max_capacity  = each.value.ecs_autoscaling_max_capacity
  ecs_autoscaling_min_capacity  = each.value.ecs_autoscaling_min_capacity
  ecs_environment               = each.value.ecs_environment
  ecs_task_policy_arns          = each.value.ecs_task_policy_arns
  ecs_cpu_architecture          = each.value.ecs_cpu_architecture
  enable_ecs_exec               = each.value.enable_ecs_exec
  ecs_cloudwatch_log_group_name = module.ecs_cluster.cloudwatch_log_group_name
  # lb
  lb_healthcheck_interval            = each.value.lb_healthcheck_interval
  lb_healthcheck_path                = each.value.lb_healthcheck_path
  lb_healthcheck_timeout             = each.value.lb_healthcheck_timeout
  lb_healthcheck_healthy_threshold   = each.value.lb_healthcheck_healthy_threshold
  lb_healthcheck_unhealthy_threshold = each.value.lb_healthcheck_unhealthy_threshold
  lb_healthcheck_matcher             = each.value.lb_healthcheck_matcher
  lb_delete_protection               = each.value.lb_delete_protection
  # network
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
}
