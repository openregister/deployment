module "country" {
  source = "../modules/register"
  id = "country"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  elb_subnet_ids = "${module.core.public_subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = 1
  user_data = "${template_file.user_data.rendered}"
  config_bucket = "${module.core.s3_bucket_name}"
}
