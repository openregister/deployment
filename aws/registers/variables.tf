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

// openregister app
variable "openregister_cidr_blocks" { type = "list" }
variable "openregister_database_cidr_blocks" { type = "list" }
variable "openregister_database_class_instance" {
  default = "db.t2.micro"
}
variable "openregister_database_master_password" {}
variable "openregister_database_apply_immediately" { default = false }

/*

 === Register toggles ===

 This *instance_count* block defines default registers

 Setting a register to 0 will disable register (or remove if register was already provisioned)

 To toggle register(s) per environment use registers/environments/<name>.tfvars instead, e.g.:

 $ grep instance_count environments/alpha.tfvars

 > instance_count.school = 1
 > instance_count.street = 1

 will provision school and street with single EC2 instances for each register.

*/

variable "instance_count" {
  default = {
    // Core registers
    "datatype" = 1
    "field" = 1
    "public-body" = 0
    "register" = 1

    "academy-school-eng" = 0
    "address" = 0
    "company" = 0
    "country" = 0
    "court" = 0
    "denomination" = 0
    "dental-practice" = 0
    "diocese" = 0
    "food-authority" = 0
    "food-premises" = 0
    "food-premises-rating" = 0
    "food-premises-type" = 0
    "government-domain" = 0
    "government-organisation" = 0
    "government-website" = 0
    "gp-practice" = 0
    "industry" = 0
    "internal-drainage-board" = 0
    "job-centre" = 0
    "jobcentre" = 0
    "la-maintained-school-eng" = 0
    "local-authority" = 0
    "local-authority-eng" = 0
    "local-authority-nir" = 0
    "local-authority-sct" = 0
    "local-authority-type" = 0
    "local-authority-wls" = 0
    "place" = 0
    "police-force" = 0
    "premises" = 0
    "prison" = 0
    "register-office" = 0
    "religious-character" = 0
    "school" = 0
    "school-admissions-policy" = 0
    "school-authority" = 0
    "school-authority-eng" = 0
    "school-eng" = 0
    "school-federation" = 0
    "school-gender" = 0
    "school-phase" = 0
    "school-tag" = 0
    "school-trust" = 0
    "school-type" = 0
    "social-housing-provider" = 0
    "street" = 0
    "street-custodian" = 0
    "territory" = 0
    "uk" = 0
  }
}

// CodeDeploy
variable "codedeploy_service_role_arn" {
  default = "arn:aws:iam::022990953738:role/code-deploy-role"
}

// https
variable "elb_certificate_arn" {}
variable "cloudfront_certificate_arn" {
  default = ""
}

variable "enable_cdn" {}

// StatusCake
variable "statuscake_username" {}
variable "statuscake_apikey" {}

variable "enable_availability_checks" {}
