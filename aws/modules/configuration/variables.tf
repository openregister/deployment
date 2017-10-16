variable "environment_name" {}

variable "sumologic_key" {}

variable "logit_stack_id" {
  description = "The Logit.io stack to push logs to"
}

variable "logit_tcp_ssl_port" {
  description = "The Logit.io TCP+SSL port for the stack"
}

variable "influxdb_configuration" {
  type = "map"
  description = "Configuration options for InfluxDB"
}

