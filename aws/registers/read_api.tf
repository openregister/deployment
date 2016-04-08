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

module "presentation_db" {
  source = "../modules/database"
  id = "${module.core.vpc_name}-presentation-db"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.presentation_database_cidr_block}"

  allow_from = "${var.presentation_cidr_block} ${var.indexer_cidr_block}"

  instance_class = "${var.presentation_database_class_instance}"
  parameter_group_name = "${lookup(var.rds_parameter_group_name, "presentation")}"

  username = "${var.read_api_rds_username}"
  password = "${var.presentation_database_master_password}"

  apply_immediately = "${var.presentation_database_apply_immediately}"
}

module "presentation_codedeploy" {
  source = "../modules/codedeploy_group"
  id = "${var.vpc_name}"
  application = "presentation-app"
  service_role_arn = "${var.codedeploy_service_role_arn}"
  tag = "${var.vpc_name}-presentation_app"
}
