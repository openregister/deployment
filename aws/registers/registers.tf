module "address_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "address", false)}"

  name = "address"
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

module "academy-school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "academy-school-eng", false)}"

  name = "academy-school-eng"
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

module "approved-meat-establishment_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "approved-meat-establishment", false)}"

  name = "approved-meat-establishment"
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

module "charity" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "charity", false)}"

  name = "charity"
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

module "charity-class" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "charity-class", false)}"

  name = "charity-class"
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

module "clinical-commissioning-group_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "clinical-commissioning-group", false)}"

  name = "clinical-commissioning-group"
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

module "company_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "company", false)}"

  name = "company"
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

module "diocese_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "diocese", false)}"

  name = "diocese"
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

module "food-authority_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-authority", false)}"

  name = "food-authority"
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

module "food-premises_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises", false)}"

  name = "food-premises"
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

module "food-premises-rating_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises-rating", false)}"

  name = "food-premises-rating"
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

module "food-premises-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "food-premises-type", false)}"

  name = "food-premises-type"
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

module "green-deal-certification-body_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "green-deal-certification-body", false)}"

  name = "green-deal-certification-body"
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

module "industrial-classification_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "industrial-classification", false)}"

  name = "industrial-classification"
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

module "la-maintained-school-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "la-maintained-school-eng", false)}"

  name = "la-maintained-school-eng"
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

module "local-authority-wls_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "local-authority-wls", false)}"

  name = "local-authority-wls"
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

module "meat-establishment-operation_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "meat-establishment-operation", false)}"

  name = "meat-establishment-operation"
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

module "meat-establishment-outcome_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "meat-establishment-outcome", false)}"

  name = "meat-establishment-outcome"
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

module "meat-establishment-type_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "meat-establishment-type", false)}"

  name = "meat-establishment-type"
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

module "place_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "place", false)}"

  name = "place"
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

module "police-force_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "police-force", false)}"

  name = "police-force"
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

module "police-neighbourhood_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "police-neighbourhood", false)}"

  name = "police-neighbourhood"
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

module "premises_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "premises", false)}"

  name = "premises"
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

module "prison_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "prison", false)}"

  name = "prison"
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

module "qualification-subject_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "qualification-subject", false)}"

  name = "qualification-subject"
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

module "religious-character_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "religious-character", false)}"

  name = "religious-character"
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

module "school-admissions-policy_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-admissions-policy", false)}"

  name = "school-admissions-policy"
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

module "school-authority-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-authority-eng", false)}"

  name = "school-authority-eng"
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

module "school-gender_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-gender", false)}"

  name = "school-gender"
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

module "school-phase_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-phase", false)}"

  name = "school-phase"
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

module "school-tag_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-tag", false)}"

  name = "school-tag"
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

module "school-trust_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "school-trust", false)}"

  name = "school-trust"
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

module "statistical-geography-metropolitan-counties-eng_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "statistical-geography-metropolitan-counties-eng", false)}"

  name = "statistical-geography-metropolitan-counties-eng"
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

module "street_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "street", false)}"

  name = "street"
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

module "street-custodian_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "street-custodian", false)}"

  name = "street-custodian"
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

module "uk_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "uk", false)}"

  name = "uk"
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

module "vehicle-colour_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "vehicle-colour", false)}"

  name = "vehicle-colour"
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

module "westminster-parliamentary-constituency_register" {
  source = "../modules/register"
  enabled = "${lookup(var.enabled_registers, "westminster-parliamentary-constituency", false)}"

  name = "westminster-parliamentary-constituency"
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
