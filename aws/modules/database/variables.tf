variable "id" {}
variable "name" {
  default = ""
}

variable "vpc_name" {}
variable "vpc_id" {}
variable "cidr_blocks" { type = "list" }

variable "count" {
  default = "1"
}

variable "password" {}
variable "username" {}

variable "multi_az" {
  default = "false"
}

/*
 * RDS Instance parameters
*/

variable "allocated_storage" {
  default = "5"
}

variable "backup_retention_period" {
  default = "1"
}

variable "db_parameter_group_name" {
  default = "postgresrdsgroup"
}

variable "engine" {
  default = "postgres"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "maintenance_window" {}

variable "parameter_group_name" {
  default = "postgresrdsgroup"
}

variable "apply_immediately" {
  default = false
}

variable "zones" {
  default = {
    "0" = "eu-west-1a"
    "1" = "eu-west-1b"
    "2" = "eu-west-1c"
  }
}
