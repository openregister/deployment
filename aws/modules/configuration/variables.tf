variable "vpc_name" {}

variable "sumologic_key" {}

variable "influxdb_configuration" {
  type = "map"
  description = "Configuration options for InfluxDB"
}

