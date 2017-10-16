module "openregister" {
  source = "../modules/openregister"
  id = "${module.core.environment_name}-openregister-app"
  environment_name = "${module.core.environment_name}"
}

