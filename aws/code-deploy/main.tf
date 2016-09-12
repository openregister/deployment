provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_codedeploy_app" "presentation_deployment_application" {
  name = "presentation_app"
}

module "presentation_app_codedeploy_group" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "presentation_app"
  code_deploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
  deploy_tag_name = "omsharma-sandbox-register"
}
