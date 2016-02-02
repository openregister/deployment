resource "aws_codedeploy_app" "indexer_deployment_application" {
  name = "indexer_app"
}

module "indexer_app_codedeploy" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "indexer_app"
  code_deploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
  deploy_tag_name = "omsharma-sandbox-indexer"
}
