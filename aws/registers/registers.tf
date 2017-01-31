resource "aws_route53_zone" "temporary_hosted_zone" {
  name = "${var.vpc_name}.openregister.org"
  comment = "Temporary whilst migrating to separate Terraform resources for each DNS record"
}

module "address_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "address", false)}"

  name = "address"
  environment = "${var.vpc_name}"
  load_balancer = "${module.address.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "academy-school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "academy-school-eng", false)}"

  name = "academy-school-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "company_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "company", false)}"

  name = "company"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "country_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "country", false)}"

  name = "country"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "datatype_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "datatype", false)}"

  name = "datatype"
  environment = "${var.vpc_name}"
  load_balancer = "${module.basic.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "diocese_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "diocese", false)}"

  name = "diocese"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "field_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "field", false)}"

  name = "field"
  environment = "${var.vpc_name}"
  load_balancer = "${module.basic.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "food-authority_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-authority", false)}"

  name = "food-authority"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "food-premises_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises", false)}"

  name = "food-premises"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "food-premises-rating_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises-rating", false)}"

  name = "food-premises-rating"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "food-premises-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises-type", false)}"

  name = "food-premises-type"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "government-domain_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "government-domain", false)}"

  name = "government-domain"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "industry_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "industry", false)}"

  name = "industry"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "jobcentre_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "jobcentre", false)}"

  name = "jobcentre"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "la-maintained-school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "la-maintained-school-eng", false)}"

  name = "la-maintained-school-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "local-authority-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-eng", false)}"

  name = "local-authority-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "local-authority-nir_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-nir", false)}"

  name = "local-authority-nir"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "local-authority-sct_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-sct", false)}"

  name = "local-authority-sct"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "local-authority-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-type", false)}"

  name = "local-authority-type"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "local-authority-wls_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-wls", false)}"

  name = "local-authority-wls"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "place_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "place", false)}"

  name = "place"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "premises_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "premises", false)}"

  name = "premises"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "prison_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "prison", false)}"

  name = "prison"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "register_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "register", false)}"

  name = "register"
  environment = "${var.vpc_name}"
  load_balancer = "${module.basic.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "religious-character_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "religious-character", false)}"

  name = "religious-character"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-admissions-policy_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-admissions-policy", false)}"

  name = "school-admissions-policy"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-authority-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-authority-eng", false)}"

  name = "school-authority-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-eng", false)}"

  name = "school-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-gender_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-gender", false)}"

  name = "school-gender"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-phase_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-phase", false)}"

  name = "school-phase"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-tag_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-tag", false)}"

  name = "school-tag"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-trust_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-trust", false)}"

  name = "school-trust"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "school-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-type", false)}"

  name = "school-type"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "street_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "street", false)}"

  name = "street"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "street-custodian_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "street-custodian", false)}"

  name = "street-custodian"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "territory_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "territory", false)}"

  name = "territory"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "uk_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "uk", false)}"

  name = "uk"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = ["${aws_route53_zone.temporary_hosted_zone.zone_id}", "${module.core.dns_zone_id}"]

  enable_availability_checks = "${var.enable_availability_checks}"
}
