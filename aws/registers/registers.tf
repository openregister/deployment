module "address_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "address", false)}"

  name = "address"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "clinical-commissioning-group_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "clinical-commissioning-group", false)}"

  name = "clinical-commissioning-group"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "green-deal-certification-body_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "green-deal-certification-body", false)}"

  name = "green-deal-certification-body"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "government-organisation_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "government-organisation", false)}"

  name = "government-organisation"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "government-service_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "government-service", false)}"

  name = "government-service"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "industrial-classification_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "industrial-classification", false)}"

  name = "industrial-classification"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "internal-drainage-board_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "internal-drainage-board", false)}"

  name = "internal-drainage-board"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "principal-local-authority_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "principal-local-authority", false)}"

  name = "principal-local-authority"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "prison-estate_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "prison-estate", false)}"

  name = "prison-estate"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "public-body_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "public-body", false)}"

  name = "public-body"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "public-body-classification_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "public-body-classification", false)}"

  name = "public-body-classification"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "occupation_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "occupation", false)}"

  name = "occupation"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "registration-district_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "registration-district", false)}"

  name = "registration-district"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "school-type-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-type-eng", false)}"

  name = "school-type-eng"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "social-housing-provider_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "social-housing-provider", false)}"

  name = "social-housing-provider"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "social-housing-provider-designation_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "social-housing-provider-designation", false)}"

  name = "social-housing-provider-designation"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "social-housing-provider-legal-entity_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "social-housing-provider-legal-entity", false)}"

  name = "social-housing-provider-legal-entity"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography", false)}"

  name = "statistical-geography"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-council-area-sct_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-council-area-sct", false)}"

  name = "statistical-geography-council-area-sct"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-unitary-authority-wls_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-unitary-authority-wls", false)}"

  name = "statistical-geography-unitary-authority-wls"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
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
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "vehicle-colour_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "vehicle-colour", false)}"

  name = "vehicle-colour"
  environment = "${var.vpc_name}"
  load_balancer = "${module.multi.load_balancer}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}
