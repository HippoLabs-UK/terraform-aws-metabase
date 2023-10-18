resource "aws_ecs_cluster" "cluster" {
  name = "metabase-${var.environment}-cluster"

  tags = merge(var.default_tags, var.tags)
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "metabase-${var.environment}-service"
  cluster                            = aws_ecs_cluster.cluster.id
  launch_type                        = "EC2"
  task_definition                    = aws_ecs_task_definition.task_definition.arn
  desired_count                      = var.desired_capacity
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 10

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "metabase"
    container_port   = 3000
  }

  tags = merge(var.default_tags, var.tags)
}
