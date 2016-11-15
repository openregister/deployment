variable "from" {
  description = "Domain name to redirect from"
}
variable "to" {
  description = "Hostname (optionally with http:// or https:// scheme prefix) to redirect requests to"
}
variable "certificate_arn" {
  description = "ARN of certificate to use for TLS support"
}
variable "dns_zone_id" {
  description = "ID of Route 53 hosted zone to host DNS record for name in `from` variable"
}
variable "enabled" {
  description = "Whether to enable redirect or not"
}
