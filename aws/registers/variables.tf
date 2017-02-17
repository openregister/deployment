variable "aws_region" {
  default = "eu-west-1"
}

// VPC Configuration

variable "vpc_name" {
  description = "VPC name"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "read_api_rds_username" {
  default = "postgres"
}

/*
 * Subnets
*/

// Public network used by ELBs and NAT instance
variable "public_cidr_blocks" { type = "list" }

variable "admin_ips" { type = "list" }

// RDS Configuration
variable "rds_parameter_group_name" {
  default = {
    "openregister" = "postgresrdsgroup-9-5-2"
  }
}

variable "rds_allocated_storage" {
  default = {
    "openregister" = 5
  }
}

variable "rds_maintenance_window" {}

// openregister app
variable "openregister_cidr_blocks" { type = "list" }
variable "openregister_database_cidr_blocks" { type = "list" }
variable "openregister_database_class_instance" {
  default = "db.t2.micro"
}
variable "openregister_database_master_password" {}
variable "openregister_database_apply_immediately" { default = false }

variable "group_instance_count" {
  type = "map"
  default = {}
}

variable "group_instance_type" {
  type = "map"
  default = {}
}

variable "enabled_redirects" {
  type = "map"
  default = {}
}

variable "enabled_registers" {
  type = "map"
  default = {}
}

// CodeDeploy
variable "codedeploy_service_role_arn" {
  default = "arn:aws:iam::022990953738:role/code-deploy-role"
}

// https
variable "elb_certificate_arn" {}
variable "cloudfront_certificate_arn" {}

// StatusCake
variable "statuscake_username" {}
variable "statuscake_apikey" {}
variable "enable_availability_checks" {}

variable "cdn_configuration" {
  type = "map"
  default = {
    enabled = false
  }
}

variable "sumologic_key" {
  description = "The key fluentd uses to log to Sumo Logic"
}

variable "influxdb_password" {
  description = "Password used to connect to influxdb. Defined outside of `influxdb_configuration` due to the way we pass in secrets from `pass` through `TF_VARS_*`."
}
variable "influxdb_configuration" {
  type = "map"
  description = "Configuration options for InfluxDB"
}
