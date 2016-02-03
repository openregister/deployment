module "indexer" {
  source = "../modules/indexer"
  id = "${module.core.vpc_name}-indexer"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.write_api_indexer_cidr_block}"

  mint_db_cidr_block = "${var.write_api_database_cidr_block}"
  presentation_db_cidr_block = "${var.read_api_database_cidr_block}"

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

  cidr_block = "${var.write_api_database_cidr_block}"

  allow_from = "${var.write_api_mint_cidr_block} ${var.write_api_indexer_cidr_block}"

  username = "${var.read_api_rds_username}"
  password = "${var.read_api_rds_password}"
}

module "mint" {
  source = "../modules/mint"
  id = "${module.core.vpc_name}-mint-app"
  register = "country"

  vpc_name = "${module.core.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  cidr_block = "${var.write_api_mint_cidr_block}"
  db_cidr_block = "${var.write_api_database_cidr_block}"

  nat_gateway_id = "${module.core.nat_gateway_id}"
  nat_private_ip = "${module.core.nat_private_ip}"

  instance_count = 1
  user_data = "${template_file.user_data.rendered}"
}
