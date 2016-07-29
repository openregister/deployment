module "openregister" {
  source = "../modules/openregister"
  id = "${module.core.vpc_name}-openregister-app"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.openregister_cidr_block}"
  db_cidr_block = "${var.openregister_database_cidr_block}"

  nat_gateway_id = "${module.core.nat_gateway_id}"
  nat_private_ip = "${module.core.nat_private_ip}"
  public_route_table_id = "${module.core.public_route_table_id}"
}

module "openregister_db" {
  source = "../modules/database"
  id = "${module.core.vpc_name}-openregister-db"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.openregister_database_cidr_block}"

  allow_from = "${var.openregister_cidr_block} ${var.indexer_cidr_block}"

  instance_class = "${var.openregister_database_class_instance}"
  parameter_group_name = "${lookup(var.rds_parameter_group_name, "openregister")}"

  username = "${var.read_api_rds_username}"
  password = "${var.openregister_database_master_password}"

  apply_immediately = "${var.openregister_database_apply_immediately}"

  allocated_storage = "${lookup(var.rds_allocated_storage, "openregister")}"
}

module "openregister_codedeploy" {
  source = "../modules/codedeploy_group"
  id = "${var.vpc_name}"
  application = "openregister-app"
  service_role_arn = "${var.codedeploy_service_role_arn}"
  tag = "${var.vpc_name}-openregister_app"
}
