output "vpc_name" {
  value = "${module.core.vpc_name}"
}

output "vpc_id" {
  value = "${module.core.vpc_id}"
}

output "gateway" {
  value = "${module.core.nat_fqdn_address}"
}
