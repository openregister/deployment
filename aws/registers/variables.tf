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
variable "public_cidr_block" {}

variable "admin_ips" {}

// Read APIs
variable "presentation_cidr_block" {}
variable "presentation_database_cidr_block" {}
variable "presentation_database_class_instance" {
  default = "db.t2.micro"
}
variable "presentation_database_master_password" {}

// Write APIs
variable "indexer_cidr_block" {}
variable "mint_cidr_block" {}
variable "mint_database_cidr_block" {}
variable "mint_database_master_password" {}

/*
 * Registers
*/

variable "register_country_presentation_instance_count" { default = 1 }
variable "register_country_mint_instance_count" { default = 1 }

variable "register_datatype_presentation_instance_count" { default = 1 }
variable "register_datatype_mint_instance_count" { default = 1 }

variable "register_field_presentation_instance_count" { default = 1 }
variable "register_field_mint_instance_count" { default = 1 }

variable "register_public_body_presentation_instance_count" { default = 1 }
variable "register_public_body_mint_instance_count" { default = 1 }

variable "register_register_presentation_instance_count" { default = 1 }
variable "register_register_mint_instance_count" { default = 1 }
