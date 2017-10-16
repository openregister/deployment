variable "environment_name" {}

variable "zones" {
  default = {
    "0" = "eu-west-1a"
    "1" = "eu-west-1b"
    "2" = "eu-west-1c"
  }
}


/*
 * route53.tf
*/

variable "dns_ttl" {
  default = "300"
}

variable "dns_domain" {
  default = "openregister.org"
}

variable "soa_negative_cache_ttl" {
  default = 3600
  description = "The length of time `NXDOMAIN` responses from our authoritative nameservers should be cached by recursors for"
}

variable "cdn_configuration" {
  type = "map"
}
