<p align="center">
    <img height="50" src="https://github.com/HippoLabs-UK/terraform-aws-metabase/blob/main/docs/logo.png">
</p>

## Metabase on AWS
Terraform module for setting up a self-hosted Metabase solution on AWS.

## Infrastructure architecture
<img src="https://github.com/HippoLabs-UK/terraform-aws-metabase/blob/main/docs/architecture.png" alt="text" width="800"/>


## Usage
See [`examples`](https://github.com/HippoLabs-UK/terraform-aws-metabase/tree/main/examples) directory for working examples to reference:

```hcl
module "metabase" {
  source = "HippoLabs-UK/metabase/aws"

  region                              = var.region
  environment                         = var.environment
  metabase_db_credentials_secret_name = var.metabase_db_credentials_secret_name
  vpc_id                              = var.vpc_id
  private_subnet_ids                  = var.private_subnet_ids
  public_subnet_ids                   = var.public_subnets_ids
}
```

## Pre-requisites
1. **[Required]** Create a key-value pair secret in AWS Secrets Manager. The key should be `password` and the value will be the master password to use for the Metabase backend database.
The password must be of 8–41 characters long and can include any printable ASCII character except /, ', ", @, or a space.
The secret name can be passed to the module using the `metabase_db_credentials_secret_name` variable.


2. **[Optional]** Create and validate a public certificate in AWS Certificate Manager. The certificate ARN can then be passed to the Metabase module using the `ssl_certificate` variable. This will enable HTTPS traffic.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.ecs_task_logger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.metabase_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.metabase_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.ecs_instance_role_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecsTaskExecutionPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_instance_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.ecs_launch_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_target_listener_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.alb_target_listener_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.metabase_alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.metabase_ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.metabase_rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.ecs_instance_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ecs_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_instance_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret.metabase_db_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.metabase_current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ip_list"></a> [allow\_ip\_list](#input\_allow\_ip\_list) | Allowed IP list for Metabase access | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_bastion_host_security_group_ids"></a> [bastion\_host\_security\_group\_ids](#input\_bastion\_host\_security\_group\_ids) | Security group ids of the bastion hosts to enable SSH tunneling access to the Metabase backend database | `list(string)` | `[]` | no |
| <a name="input_db_allocated_storage"></a> [db\_allocated\_storage](#input\_db\_allocated\_storage) | The storage in GB allocated to the Metabase backend database | `number` | `10` | no |
| <a name="input_db_instance_type"></a> [db\_instance\_type](#input\_db\_instance\_type) | EC2 instance type for the backend RDS database | `string` | `"db.t3.micro"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default resource tags | `map(string)` | <pre>{<br>  "project": "metabase"<br>}</pre> | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired capacity for the EC2 auto-scaling group | `number` | `1` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | ECS Task CPU | `number` | `1024` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | ECS Task Memory Reservation | `number` | `1678` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name - used in resource names, e.g production | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type the Metabase application will be running on | `string` | `"t3.small"` | no |
| <a name="input_log_retention_period"></a> [log\_retention\_period](#input\_log\_retention\_period) | Cloudwatch logs retention period | `number` | `14` | no |
| <a name="input_metabase_db_credentials_secret_name"></a> [metabase\_db\_credentials\_secret\_name](#input\_metabase\_db\_credentials\_secret\_name) | Secrets Manager secret ARN that stores the Metabase backend database master password | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs associated with the VPC | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs associated with the VPC | `list(string)` | n/a | yes |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | Metabase backend database backup retention period | `number` | `7` | no |
| <a name="input_rds_backup_window"></a> [rds\_backup\_window](#input\_rds\_backup\_window) | Metabase backend database backup window period | `string` | `"23:00-23:50"` | no |
| <a name="input_rds_maintenance_window"></a> [rds\_maintenance\_window](#input\_rds\_maintenance\_window) | Metabase backend database maintenance window period | `string` | `"Sat:02:00-Sat:03:00"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources should be deployed | `string` | n/a | yes |
| <a name="input_ssl_certificate"></a> [ssl\_certificate](#input\_ssl\_certificate) | SSL certificate ARN for the Metabase load balancer | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC where resources should be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns"></a> [alb\_dns](#output\_alb\_dns) | Application Load Balancer DNS to access Metabase |
| <a name="output_metabase_ecs_security_group_id"></a> [metabase\_ecs\_security\_group\_id](#output\_metabase\_ecs\_security\_group\_id) | Security Group Id to whitelist of Metabase will need to connect to a private RDS database in the same VPC |
| <a name="output_rds_host"></a> [rds\_host](#output\_rds\_host) | Metabase Backend Database Host name |
<!-- END_TF_DOCS -->


## License
Apache-2.0 Licensed. See [LICENSE](LICENSE).
