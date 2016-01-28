output "vpc_name" {
  value = "${module.core.vpc_name}"
}

output "vpc_id" {
  value = "${module.core.vpc_id}"
}

output "nat_public_ip" {
  value = "${module.core.nat_public_ip}"
}
