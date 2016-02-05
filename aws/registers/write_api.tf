module "indexer" {
  source = "../modules/indexer"
  id = "${module.core.vpc_name}-indexer"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.indexer_cidr_block}"
  db_cidr_block = "${var.presentation_database_cidr_block} ${var.mint_database_cidr_block}"

  nat_gateway_id = "${module.core.nat_gateway_id}"
  nat_private_ip = "${module.core.nat_private_ip}"

  instance_count = 1
  user_data = "${template_file.user_data.rendered}"
}

module "mint_db" {
  source = "../modules/database"
  id = "${module.core.vpc_name}-mint-db"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.mint_database_cidr_block}"

  allow_from = "${var.mint_cidr_block} ${var.indexer_cidr_block}"

  username = "${var.read_api_rds_username}"
  password = "${var.mint_database_master_password}"
}

module "mint" {
  source = "../modules/mint"
  id = "${module.core.vpc_name}-mint-app"
  register = "country"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.mint_cidr_block}"
  db_cidr_block = "${var.mint_database_cidr_block}"

  nat_gateway_id = "${module.core.nat_gateway_id}"
  nat_private_ip = "${module.core.nat_private_ip}"

  instance_count = 1
  user_data = "${template_file.user_data.rendered}"
}
