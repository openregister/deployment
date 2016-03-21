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
variable "presentation_database_apply_immediately" { default = false }

// Write APIs
variable "indexer_cidr_block" {}
variable "mint_cidr_block" {}
variable "mint_database_cidr_block" {}
variable "mint_database_master_password" {}
variable "mint_database_apply_immediately" { default = false }

/*

 === Register toggles ===

 This *instance_count* block defines default registers

 Setting a register to 0 will disable register (or remove if register was already provisioned)

 To toggle register(s) per environment use registers/environments/<name>.tfvars instead, e.g.:

 $ grep instance_count environments/alpha.tfvars

 > instance_count.street-classification = 1
 > instance_count.street-surface = 1

 will provision street-classification and street-surface with single EC2 instances for each register.

*/

variable "instance_count" {
  default = {
    // Core registers
    "datatype" = 1
    "field" = 1
    "public-body" = 0
    "register" = 1

    // Country register
    "country" = 0

    // Address registers
    "address" = 0
    "locality" = 0
    "postcode" = 0
    "street" = 0
    "street-classification" = 0
    "street-surface" = 0
    "town" = 0
  }
}

// CodeDeploy
variable "codedeploy_service_role_arn" {
  default = "arn:aws:iam::022990953738:role/code-deploy-role"
}
