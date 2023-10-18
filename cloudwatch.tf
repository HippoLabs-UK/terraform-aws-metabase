resource "aws_cloudwatch_log_group" "ecs_task_logger" {
  name = "/ecs/metabase-${var.environment}"

  retention_in_days = var.log_retention_period
  tags              = merge(var.default_tags, var.tags)
}
