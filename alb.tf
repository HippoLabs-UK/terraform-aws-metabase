resource "aws_lb_target_group" "target_group" {
  name     = "metabase-${var.environment}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  load_balancing_algorithm_type = "round_robin"
  slow_start                    = 30 # 30 seconds
  target_type                   = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30 # 30 seconds
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    timeout             = 15 # 15 seconds
    unhealthy_threshold = 3
  }

  tags = merge(var.default_tags, var.tags)
}

resource "aws_lb" "load_balancer" {
  name               = "metabase-${var.environment}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.metabase_alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  enable_http2 = true

  tags = merge(var.default_tags, var.tags)
}

resource "aws_lb_listener" "alb_target_listener_http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = merge(var.default_tags, var.tags)
}

resource "aws_lb_listener" "alb_target_listener_https" {
  count = var.ssl_certificate == "" ? 0 : 1

  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.ssl_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = merge(var.default_tags, var.tags)
}
