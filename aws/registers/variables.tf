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

// NAT network
variable "management_cidr_block" {}

// Read API
variable "read_api_cidr_block" {}
variable "read_api_database_cidr_block" {}

// Write API
variable "write_api_database_cidr_block" {}
variable "write_api_indexer_cidr_block" {}
variable "write_api_mint_cidr_block" {}
