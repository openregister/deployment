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
variable "rds_allocated_storage" {
  default = {
    "openregister" = 5
  }
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_maintenance_window" {}

// openregister app
variable "openregister_cidr_blocks" { type = "list" }
variable "openregister_database_cidr_blocks" { type = "list" }
variable "openregister_database_class_instance" {
  default = "db.t2.micro"
}
variable "openregister_database_multi_az" { default = false }
variable "openregister_database_master_password" {}
variable "openregister_database_apply_immediately" { default = false }



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
variable "cloudfront_certificate_arn" { default = "" }
variable "paas_cdn_certificate_arn" {}

// Pingdom
variable "pingdom_user" {}
variable "pingdom_password" {}
variable "pingdom_api_key" {}
variable "pingdom_contact_ids" {}
variable "enable_availability_checks" {}

variable "cdn_configuration" {
  type = "map"
  default = {
    enabled = false
  }
}

variable "paas_cdn_configuration" {
  type = "map"
}

variable "sumologic_key" {
  description = "The key fluentd uses to log to Sumo Logic"
}

variable "logit_stack_id" {
  description = "The Logit.io stack to push logs to"
}

variable "logit_tcp_ssl_port" {
  description = "The Logit.io TCP+SSL port for the stack"
}

variable "influxdb_password" {
  description = "Password used to connect to influxdb. Defined outside of `influxdb_configuration` due to the way we pass in secrets from `pass` through `TF_VARS_*`."
}

variable "influxdb_configuration" {
  type = "map"
  description = "Configuration options for InfluxDB"
}
