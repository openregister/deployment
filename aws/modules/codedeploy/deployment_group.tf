resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name = "${var.code_deploy_application_name}"
  deployment_group_name = "${var.code_deploy_application_name}_deployment_group"
  service_role_arn = "${var.codedeploy_role_arn}"
  ec2_tag_filter {
    key = "AppServer"
    type = "KEY_AND_VALUE"
    value = "omsharma-sandbox-register"
  }
}
