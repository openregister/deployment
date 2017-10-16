module "openregister" {
  source = "../modules/openregister"
  id = "${module.core.environment_name}-openregister-app"

  environment_name = "${module.core.environment_name}"
}


module "openregister_codedeploy" {
  source = "../modules/codedeploy_group"
  id = "${var.environment_name}"
  application = "openregister-app"
  service_role_arn = "${var.codedeploy_service_role_arn}"
  tag = "${var.environment_name}-openregister"
}
