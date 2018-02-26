module "allergen_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "allergen", false)}"

  name = "allergen"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "fire-authority_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "fire-authority", false)}"

  name = "fire-authority"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "jobcentre-district_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "jobcentre-district", false)}"

  name = "jobcentre-district"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "jobcentre-group_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "jobcentre-group", false)}"

  name = "jobcentre-group"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "public-body-account_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "public-body-account", false)}"

  name = "public-body-account"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "public-body-account-classification_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "public-body-account-classification", false)}"

  name = "public-body-account-classification"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "qualification-assessment-method_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "qualification-assessment-method", false)}"

  name = "qualification-assessment-method"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "qualification-level_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "qualification-level", false)}"

  name = "qualification-level"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "qualification-sector-subject-area_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "qualification-sector-subject-area", false)}"

  name = "qualification-sector-subject-area"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "qualification-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "qualification-type", false)}"

  name = "qualification-type"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "social-housing-provider-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "social-housing-provider-eng", false)}"

  name = "social-housing-provider-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "social-housing-provider-designation-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "social-housing-provider-designation-eng", false)}"

  name = "social-housing-provider-designation-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "social-housing-provider-legal-entity-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "social-housing-provider-legal-entity-eng", false)}"

  name = "social-housing-provider-legal-entity-eng"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-county-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-county-eng", false)}"

  name = "statistical-geography-county-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-local-government-district-nir_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-local-government-district-nir", false)}"

  name = "statistical-geography-local-government-district-nir"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-london-borough-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-london-borough-eng", false)}"

  name = "statistical-geography-london-borough-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-metropolitan-district-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-metropolitan-district-eng", false)}"

  name = "statistical-geography-metropolitan-district-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-registration-district-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-registration-district-eng", false)}"

  name = "statistical-geography-registration-district-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-registration-district-wls_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-registration-district-wls", false)}"

  name = "statistical-geography-registration-district-wls"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-non-metropolitan-district-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-non-metropolitan-district-eng", false)}"

  name = "statistical-geography-non-metropolitan-district-eng"
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}

module "statistical-geography-unitary-authority-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-unitary-authority-eng", false)}"

  name = "statistical-geography-unitary-authority-eng"
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
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
  environment = "${var.environment_name}"
  dns_zone_id = "${module.core.dns_zone_id}"

  enable_availability_checks = "${var.enable_availability_checks}"
  cdn_configuration = "${var.cdn_configuration}"
  cdn_s3_origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
  cdn_dns_zone_id = "${module.core.cdn_dns_zone_id}"
  paas_cdn_domain_name = "${aws_cloudfront_distribution.paas_cdn.domain_name}"
  paas_cdn_hosted_zone_id = "${aws_cloudfront_distribution.paas_cdn.hosted_zone_id}"
  pingdom_contact_ids = "${var.pingdom_contact_ids}"
}
