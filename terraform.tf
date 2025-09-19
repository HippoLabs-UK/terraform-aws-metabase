terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0" # Lets manage major version bumps ourselves to stop things break. 
    }
  }
}
