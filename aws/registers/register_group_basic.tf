module "basic" {
  source = "../modules/register_group"
  id = "basic"

  instance_ami = "${data.aws_ami.ubuntu-hvm-ebs-ssd.image_id}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"
  user_data = "${file("templates/users.yaml")}"

  database_security_group_id = "${module.openregister_db.security_group_id}"
  bastion_security_group_id = "${module.core.bastion_security_group_id}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
