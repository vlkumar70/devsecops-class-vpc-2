## Provider
provider "aws" {
  region = var.region
}

## Terraform version
terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.5"
    }
  }
}

## Terraform state backend
terraform {
  backend "s3" {
    bucket         = "devsecops-class-terraform-bucket-state"
    key            = "devsecops/vpc_ec2.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "devsecops-class-terraform-bucket-state"
  }
}
