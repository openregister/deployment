module "presentation" {
  source = "../modules/presentation"
  id = "${module.core.vpc_name}-presentation-app"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.read_api_cidr_block}"
  nat_gateway_id = "${module.core.nat_gateway_id}"
  nat_private_ip = "${module.core.nat_private_ip}"
}

module "presentation_db" {
  source = "../modules/database"
  id = "${module.core.vpc_name}-presentation-db"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.read_api_database_cidr_block}"

  username = "${var.read_api_rds_username}"
  password = "${var.read_api_rds_password}"
}

resource "aws_security_group_rule" "outbound_postgres" {
  security_group_id = "${module.presentation.security_group_id}"
  type = "egress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${module.presentation_db.security_group_id}"
}

resource "aws_security_group_rule" "inbound_presentation" {
  security_group_id = "${module.presentation_db.security_group_id}"
  type = "ingress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${module.presentation.security_group_id}"
}
