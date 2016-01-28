module "country" {
  source = "../modules/register"
  id = "country"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = 1
  user_data = "${template_file.user_data.rendered}"
  config_bucket = "${module.core.s3_bucket_name}"

  //rds_instance = "${module.presentation_db.rds_instance}"

}

module "company" {
  source = "../modules/register"
  id = "company"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = 0
  user_data = "${template_file.user_data.rendered}"
  config_bucket = "${module.core.s3_bucket_name}"

  //rds_instance = "${module.presentation_db.rds_instance}"
}

module "location" {
  source = "../modules/register"
  id = "location"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = 0
  user_data = "${template_file.user_data.rendered}"
  config_bucket = "${module.core.s3_bucket_name}"

  //rds_instance = "${module.presentation_db.rds_instance}"
}
