data "aws_caller_identity" "current" {}
data "aws_region" "current" { current = true }

resource "aws_codebuild_project" "deploy_to_paas" {
  name = "${var.environment}-${var.register_group}-deploy"
  description = "Deploy the \"${var.register_group}\" register group to the \"${var.environment}\" environment on PaaS"
  build_timeout = "30"
  service_role = "${var.codebuild_role_arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ubuntu-base:14.04"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "CF_ORGANIZATION"
      "value" = "${var.cloudfoundry_organization}"
    }

    environment_variable {
      "name"  = "CF_SPACE"
      "value" = "${var.cloudfoundry_space}"
    }

    environment_variable {
      "name"  = "ENVIRONMENT"
      "value" = "${var.environment}"
    }

    environment_variable {
      "name"  = "REGISTER_GROUP"
      "value" = "${var.register_group}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
