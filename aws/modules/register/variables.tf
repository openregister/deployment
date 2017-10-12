variable name {
  description = "name of the register"
}

variable environment {
  description = "the environment which this register is in"
}

variable enabled {
  description = "is this register enabled in this environment"
}

variable dns_zone_id {
  description = "the Route 53 DNS zone to create these records in"
}

variable enable_availability_checks {
  description = "should availability checks be enabled for this register?"
}

variable cdn_configuration {
  type = "map"
  description = "should register be fronted by a CDN?"
}

variable cdn_s3_origin_access_identity {
  description = "identity that allows CloudFront to read from an S3 origin"
}

variable cdn_dns_zone_id {
  description = "hosted zone for CDN records"
}

variable paas_cdn_hosted_zone_id {
  description = "hosted zone for CDN records"
}

variable paas_cdn_domain_name {
  description = "CloudFront distribution name"
}

variable pingdom_contact_ids {
  description = "contacts to send state change notifications to"
}
