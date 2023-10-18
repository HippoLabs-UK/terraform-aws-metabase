resource "aws_ecs_task_definition" "task_definition" {
  family                   = "metabase-${var.environment}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  container_definitions = jsonencode([
    {
      "name" : "metabase"
      "image" : "metabase/metabase"
      "essential" : true
      "memoryReservation" : var.ecs_task_memory
      "cpu" : var.ecs_task_cpu

      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.ecs_task_logger.name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
        }
      }

      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000
        },
      ]

      "environment" : [
        {
          "name" : "MB_DB_DBNAME",
          "value" : aws_db_instance.metabase_db.db_name
        },
        {
          "name" : "MB_DB_HOST",
          "value" : aws_db_instance.metabase_db.address
        },
        {
          "name" : "MB_DB_PORT",
          "value" : tostring(aws_db_instance.metabase_db.port)
        },
        {
          "name" : "MB_DB_TYPE",
          "value" : aws_db_instance.metabase_db.engine
        },
        {
          "name" : "MB_DB_USER",
          "value" : aws_db_instance.metabase_db.username
        },
        {
          "name" : "MB_DB_PASS",
          "value" : jsondecode(data.aws_secretsmanager_secret_version.metabase_current.secret_string)["password"]
        }
      ]
    }
  ])
}
