variable "environment" {
  type        = string
  description = "Environment name - used in resource names, e.g production"
}

variable "region" {
  type        = string
  description = "AWS region where resources should be deployed"
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC where resources should be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs associated with the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs associated with the VPC"
}

variable "allow_ip_list" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Allowed IP list for Metabase access"
}

variable "ssl_certificate" {
  type        = string
  default     = ""
  description = "SSL certificate ARN for the Metabase load balancer"
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "EC2 instance type the Metabase application will be running on"
}

variable "desired_capacity" {
  type        = number
  default     = 1
  description = "Desired capacity for the EC2 auto-scaling group"
}

variable "ecs_task_cpu" {
  type        = number
  default     = 1024
  description = "ECS Task CPU"
}

variable "ecs_task_memory" {
  type        = number
  default     = 1678
  description = "ECS Task Memory Reservation"
}

variable "log_retention_period" {
  type        = number
  default     = 14
  description = "Cloudwatch logs retention period"
}

variable "db_instance_type" {
  type        = string
  default     = "db.t3.micro"
  description = "EC2 instance type for the backend RDS database"
}

variable "metabase_db_credentials_secret_name" {
  type        = string
  description = "Secrets Manager secret ARN that stores the Metabase backend database master password"
}

variable "db_allocated_storage" {
  type        = number
  default     = 10
  description = "The storage in GB allocated to the Metabase backend database"
}

variable "rds_backup_window" {
  type        = string
  default     = "23:00-23:50"
  description = "Metabase backend database backup window period"
}

variable "rds_maintenance_window" {
  type        = string
  default     = "Sat:02:00-Sat:03:00"
  description = "Metabase backend database maintenance window period"
}

variable "rds_backup_retention_period" {
  type        = number
  default     = 7
  description = "Metabase backend database backup retention period"
}

variable "bastion_host_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids of the bastion hosts to enable SSH tunneling access to the Metabase backend database"
}

variable "default_tags" {
  type = map(string)
  default = {
    "project" = "metabase"
  }
  description = "Default resource tags"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional resource tags"
}

variable "lb_drop_invalid_header_fields" {
  type        = bool
  default     = false
  description = "Drop invalid HTTP request headers in load balancer"
}
