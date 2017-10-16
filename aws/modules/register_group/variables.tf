variable "id" {
  description = "name of register"
}
variable "instance_count" {
  default = 1
  description = "number of EC2 instances to provision (0 means to disable completely)"
}
variable "vpc_name" {
  description = "name of vpc to install into"
}
variable "vpc_id" {
  description = "id of vpc to install into"
}

variable "instance_ami" {
  default = "ami-98ecb7fe"
  description = "AMI to use for the register EC2 instances"
}

variable "instance_type" {
  default = "t2.micro"
  description = "EC2 instance type to use for instances"
}

# FIXME can we remove this?
variable "user_data" {
  description = "User data for initializing instances"
}

variable "private_dns_zone_id" {
  description = "Route 53 hosted zone id for DNS records for EC2 instances (ie private records)"
}

variable "dns_zone_id" {
  description = "Route 53 zone id for DNS records for ELBs (ie public records)"
}

variable "dns_ttl" {
  default = "300"
  description = "TTL, in seconds, for Route 53 DNS records"
}

variable "dns_domain" {
  default = "openregister.org"
  description = "Domain for public DNS records"
}

variable "certificate_arn" {
  description = "ARN for TLS certificate for ELB"
}

variable "database_security_group_id" {
  description = "security group of the database to allow register application egress access to"
}
