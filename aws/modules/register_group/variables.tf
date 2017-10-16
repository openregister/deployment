variable "id" {
  description = "name of register"
}

variable "environment_name" {
  description = "environment name"
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
