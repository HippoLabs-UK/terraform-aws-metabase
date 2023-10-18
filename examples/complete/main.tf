provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

  name = "metabase-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  map_public_ip_on_launch = false
}

module "metabase" {
  source = "../../../terraform-aws-metabase"

  region                              = var.region
  environment                         = var.environment
  metabase_db_credentials_secret_name = var.metabase_db_credentials_secret_name
  vpc_id                              = module.vpc.vpc_id
  private_subnet_ids                  = module.vpc.private_subnets
  public_subnet_ids                   = module.vpc.public_subnets
}

output "alb_dns" {
  value = module.metabase.alb_dns
}

output "rds_host" {
  value = module.metabase.rds_host
}

output "metabase_ecs_security_group_id" {
  value = module.metabase.metabase_ecs_security_group_id
}
