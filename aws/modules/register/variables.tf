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

variable load_balancer {
  type = "map"
  description = "output from the register_group module"
}

variable enable_availability_checks {
  description = "should availability checks be enabled for this register?"
}

variable cdn_configuration {
  type = "map"
  description = "should register be fronted by a CDN?"
}
