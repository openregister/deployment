provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}


resource "aws_codedeploy_app" "presentation_deployment_application" {
  name = "presentation_app"
}

resource "aws_codedeploy_app" "mint_deployment_application" {
  name = "mint_app"
}


module "presentation_app_codedeploy_group" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "presentation_app"
  codedeploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
  deploy_tag_name = "omsharma-sandbox-register"
}

module "mint_app_codedeploy" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "mint_app"
  codedeploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
  deploy_tag_name = "omsharma-sandbox-mint"
}
