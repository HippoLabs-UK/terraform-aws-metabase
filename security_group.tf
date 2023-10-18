resource "aws_security_group" "metabase_alb_sg" {
  name        = "metabase_${var.environment}_alb_security_group"
  description = "Security group restricting incoming traffic to Metabase"

  vpc_id = var.vpc_id

  ingress {
    description = "Allowing inbound http traffic to whitelisted ips"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_ip_list
  }

  ingress {
    description = "Allowing inbound https traffic to whitelisted ips"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allow_ip_list
  }

  egress {
    description      = "Allowing all outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "metabase_ecs_sg" {
  name        = "metabase_${var.environment}_ecs_security_group"
  description = "Security group restricting incoming traffic to ECS"

  vpc_id = var.vpc_id

  ingress {
    description     = "Allowing inbound traffic from white listed IPs"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.metabase_alb_sg.id]
  }

  egress {
    description      = "Allowing all outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "metabase_rds_sg" {
  name        = "metabase_${var.environment}_rds_security_group"
  description = "Security group restricting incoming traffic to RDS"

  vpc_id = var.vpc_id

  ingress {
    description     = "Allowing inbound traffic from white listed IPs"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.bastion_host_sg == "" ? [aws_security_group.metabase_alb_sg.id, aws_security_group.metabase_ecs_sg.id] : [aws_security_group.metabase_alb_sg.id, aws_security_group.metabase_ecs_sg.id, var.bastion_host_sg]
  }

  egress {
    description      = "Allowing all outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
