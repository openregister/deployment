variable "aws_access_key" {}
variable "aws_secret_key" {}

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

variable "read_api_rds_password" {}

/*
 * Subnets
*/

// Public network used by ELBs and NAT instance
variable "public_cidr_block" {}

// Read APIs
variable "presentation_cidr_block" {}
variable "presentation_database_cidr_block" {}
variable "presentation_database_master_password" {}

// Write APIs
variable "indexer_cidr_block" {}
variable "mint_cidr_block" {}
variable "mint_database_cidr_block" {}
variable "mint_database_master_password" {}
