# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

# NOTE: Changes to identifier, multi_az, backup_retention_period, and other values
# take place at the next maintenance window by default. You can bypass this by
# passing the "apply_immediately" parameter, or by manually applying these changes
# in the AWS management interface.

variable "name" {
  type = string
}

variable "username" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "engine_version" {
  type = string
  default = "14.7"
}

variable "allocated_storage" {
  type = number
  default = 100
}

variable "security_group_ids" {
  type = list
}

variable "multi_az" {
  type = bool
  default = false
}

variable "publicly_accessible" {
  type = bool
  default = false
}

variable "vpc_id" {
  type = string
  default = ""
}

data "aws_vpc" "default" {
  default = true
}

data "aws_vpc" "selected" {
  id = (var.vpc_id == "" ? data.aws_vpc.default.id : var.vpc_id)
}

resource "aws_db_instance" "main" {
  identifier = var.name
  engine = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = 100
  storage_encrypted = true
  backup_retention_period = 35
  final_snapshot_identifier = join("-", [var.name, "final-snapshot"])
  db_subnet_group_name = (var.vpc_id == "" ? "default" : "default-${data.aws_vpc.selected.id}")
  vpc_security_group_ids = var.security_group_ids
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  multi_az = var.multi_az
  username = var.username
  manage_master_user_password = true
  auto_minor_version_upgrade  = true
  publicly_accessible = var.publicly_accessible
}
