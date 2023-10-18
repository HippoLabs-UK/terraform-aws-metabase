resource "aws_launch_template" "ecs_launch_template" {
  name                   = "metabase-${var.environment}-asg-launch-template"
  image_id               = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [aws_security_group.metabase_ecs_sg.id]
  user_data              = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config")
  instance_type          = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_role_profile.name
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "metabase-${var.environment}-autoscaling-group"
  vpc_zone_identifier       = var.private_subnet_ids
  min_size                  = 1
  max_size                  = var.desired_capacity
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = aws_launch_template.ecs_launch_template.latest_version
  }

  dynamic "tag" {
    for_each = merge(var.default_tags, var.tags)

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
