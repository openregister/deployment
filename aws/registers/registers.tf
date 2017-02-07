module "address_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "address", false)}"

  name = "address"
  environment = "${var.vpc_name}"
  load_balancer = "${module.address.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "academy-school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "academy-school-eng", false)}"

  name = "academy-school-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "company_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "company", false)}"

  name = "company"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "country_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "country", false)}"

  name = "country"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "datatype_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "datatype", false)}"

  name = "datatype"
  environment = "${var.vpc_name}"
  load_balancer = "${module.basic.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "diocese_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "diocese", false)}"

  name = "diocese"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "field_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "field", false)}"

  name = "field"
  environment = "${var.vpc_name}"
  load_balancer = "${module.basic.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "food-authority_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-authority", false)}"

  name = "food-authority"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "food-premises_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises", false)}"

  name = "food-premises"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "food-premises-rating_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises-rating", false)}"

  name = "food-premises-rating"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "food-premises-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises-type", false)}"

  name = "food-premises-type"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "government-domain_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "government-domain", false)}"

  name = "government-domain"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "industry_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "industry", false)}"

  name = "industry"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "jobcentre_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "jobcentre", false)}"

  name = "jobcentre"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "la-maintained-school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "la-maintained-school-eng", false)}"

  name = "la-maintained-school-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "local-authority-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-eng", false)}"

  name = "local-authority-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "local-authority-nir_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-nir", false)}"

  name = "local-authority-nir"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "local-authority-sct_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-sct", false)}"

  name = "local-authority-sct"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "local-authority-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-type", false)}"

  name = "local-authority-type"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "local-authority-wls_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-wls", false)}"

  name = "local-authority-wls"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "notifiable-animal-disease" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "notifiable-animal-disease", false)}"

  name = "notifiable-animal-disease"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "notifiable-animal-disease-investigation-category" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "notifiable-animal-disease-investigation-category", false)}"

  name = "notifiable-animal-disease-investigation-category"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "place_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "place", false)}"

  name = "place"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "premises_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "premises", false)}"

  name = "premises"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "prison_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "prison", false)}"

  name = "prison"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "register_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "register", false)}"

  name = "register"
  environment = "${var.vpc_name}"
  load_balancer = "${module.basic.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "religious-character_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "religious-character", false)}"

  name = "religious-character"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-admissions-policy_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-admissions-policy", false)}"

  name = "school-admissions-policy"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-authority-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-authority-eng", false)}"

  name = "school-authority-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-eng", false)}"

  name = "school-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-gender_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-gender", false)}"

  name = "school-gender"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-phase_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-phase", false)}"

  name = "school-phase"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-tag_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-tag", false)}"

  name = "school-tag"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-trust_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-trust", false)}"

  name = "school-trust"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "school-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-type", false)}"

  name = "school-type"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "street_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "street", false)}"

  name = "street"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "street-custodian_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "street-custodian", false)}"

  name = "street-custodian"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "territory_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "territory", false)}"

  name = "territory"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "uk_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "uk", false)}"

  name = "uk"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
}
