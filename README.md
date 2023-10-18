# terraform-aws-metabase
Terraform module for setting up a self-hosted Metabase solution on AWS


## Pre-requisites
1. [Optional] Validated SSL certificate to enable HTTPS traffic
2. [Required] Secrets Manager secret containing a secret key of `password` and the value to be used for the backend MySQL database.