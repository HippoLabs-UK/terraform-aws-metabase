output "alb_dns" {
  value       = aws_lb.load_balancer.dns_name
  description = "Application Load Balancer DNS to access Metabase"
}

output "rds_host" {
  value       = aws_db_instance.metabase_db.endpoint
  description = "Metabase Backend Database Host name"
}

output "metabase_ecs_security_group_id" {
  value       = aws_security_group.metabase_ecs_sg.id
  description = "Security Group Id to whitelist of Metabase will need to connect to a private RDS database in the same VPC"
}
