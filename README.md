# AWS Database Instance Module
A Terraform/OpenTofu module for quickly creating a PostgreSQL database instance in AWS

## Example Usage
Insert the following into your main.tf file:

    terraform {
      required_providers {
        aws = { 
          source  = "hashicorp/aws"
          version = "~> 5.17"
        }   
      }
      required_version = ">= 1.2.0"
    }
    
    provider "aws" {
      region  = "us-east-1"
    }

    # Database Instance
    module "example-db" {
      source = "git@github.com:strouptl/terraform-aws-database-instance.git"
      name = "example"
      username = "example"
      instance_class = "db.t4g.micro"
      engine_version = "16.1"
      security_group_ids = ["sg-123abc456def"]
    }

## Steps
1. Create your Security Group
   - Recommended: use the [aws-security-groups](https://github.com/strouptl/terraform-aws-security-groups) module
   - See "Example Usage: AWS Security Groups Module" below for details
2. Configure your options/additional options as desired.


## Additional Options
1. vpc_id (default: default VPC)
2. publicly_available \[false(default) or true\]
3. allocated_storage (default: 100)
4. multi_az \[false(default) or true\]

## Example Usage: AWS Security Groups Module

    terraform {
      required_providers {
        aws = { 
          source  = "hashicorp/aws"
          version = "~> 5.17"
        }   
      }
      required_version = ">= 1.2.0"
    }
    
    provider "aws" {
      region  = "us-east-1"
    }
  
    module "example_security_groups" {
      source = "git@github.com:strouptl/terraform-aws-security-groups.git?ref=0.1.0"
      name = "example"
    }
    
    # Database Instance
    module "example-db" {
      source = "git@github.com:strouptl/terraform-aws-database-instance.git"
      name = "example"
      username = "example"
      instance_class = "db.t4g.micro"
      engine_version = "16.1"
      security_group_ids = ["sg-123abc456def"]
      security_group_ids = [module.example_security_groups.database_instances.id]
    }
