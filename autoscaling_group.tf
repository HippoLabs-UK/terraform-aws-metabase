resource "aws_launch_configuration" "ecs_launch_config" {
  name                 = "metabase-${var.environment}-asg-launch-configuration"
  image_id             = data.aws_ami.amazon_linux_2.id
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_role_profile.name
  security_groups      = [aws_security_group.metabase_ecs_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config"
  instance_type        = var.instance_type
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "metabase-${var.environment}-autoscaling-group"
  vpc_zone_identifier       = var.private_subnet_ids
  launch_configuration      = aws_launch_configuration.ecs_launch_config.name
  min_size                  = 1
  max_size                  = var.desired_capacity
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"

  dynamic "tag" {
    for_each = merge(var.default_tags, var.tags)

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
