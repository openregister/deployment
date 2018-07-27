variable "aws_region" {
  default = "eu-west-1"
}

variable "environment_name" {
  description = "environment name"
}

variable "enabled_redirects" {
  type = "map"
  default = {}
}

variable "enabled_registers" {
  type = "map"
  default = {}
}

// https
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
