module "presentation" {
  source = "../modules/presentation"
  id = "${module.core.vpc_name}-presentation-app"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.presentation_cidr_block}"
  db_cidr_block = "${var.presentation_database_cidr_block}"

  nat_gateway_id = "${module.core.nat_gateway_id}"
  nat_private_ip = "${module.core.nat_private_ip}"
  public_route_table_id = "${module.core.public_route_table_id}"
}
