module "food-premises-rating_policy" {
  source = "../modules/instance_policy"
  id = "food-premises-rating"
  enabled = "${signum(lookup(var.instance_count, "food-premises-rating"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "food-premises-rating_openregister" {
  source = "../modules/instance"
  id = "food-premises-rating"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]

  instance_count = "${lookup(var.instance_count, "food-premises-rating")}"
  iam_instance_profile = "${module.food-premises-rating_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "food-premises-rating_elb" {
  source = "../modules/load_balancer"
  id = "food-premises-rating"
  enabled = "${signum(lookup(var.instance_count, "food-premises-rating"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.food-premises-rating_openregister.instance_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}

module "food-premises-rating" {
  source = "../modules/register"
  id = "food-premises-rating"
  instance_count = "${lookup(var.instance_count, "food-premises-rating")}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"
  subnet_ids = "${module.openregister.subnet_ids}"
  public_subnet_ids = "${module.core.public_subnet_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  user_data = "${data.template_file.user_data.rendered}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
