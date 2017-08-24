module "test_basic" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "test"
  cloudfoundry_organization = "openregister"
  environment = "test"
  register_group = "basic"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "test_multi" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "test"
  cloudfoundry_organization = "openregister"
  environment = "test"
  register_group = "multi"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "discovery_basic" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "prod"
  cloudfoundry_organization = "openregister"
  environment = "discovery"
  register_group = "basic"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "discovery_multi" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "prod"
  cloudfoundry_organization = "openregister"
  environment = "discovery"
  register_group = "multi"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "alpha_basic" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "prod"
  cloudfoundry_organization = "openregister"
  environment = "alpha"
  register_group = "basic"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "alpha_multi" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "prod"
  cloudfoundry_organization = "openregister"
  environment = "alpha"
  register_group = "multi"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "beta_basic" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "prod"
  cloudfoundry_organization = "openregister"
  environment = "beta"
  register_group = "basic"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

module "beta_multi" {
  source = "../modules/paas_codebuild_deploy"
  cloudfoundry_space = "prod"
  cloudfoundry_organization = "openregister"
  environment = "beta"
  register_group = "multi"
  codebuild_role_arn = "${aws_iam_role.codebuild_role.arn}"
}

resource "aws_codepipeline" "pipeline" {
  name = "openregister-java"
  role_arn = "${aws_iam_role.codepipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifact_store.id}"
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "TravisBuildOutput"
      category = "Source"
      owner = "AWS"
      provider = "S3"
      version = "1"
      output_artifacts = ["openregister_package"]

      configuration {
        S3Bucket = "openregister.app.artifacts"
        S3ObjectKey = "openregister-java.zip"
      }
    }
  }

  stage {
    name = "DeployToTest"

    action {
      name = "deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      version = "1"
      input_artifacts = ["openregister_package"]
      run_order = 1

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "test"
      }
    }

    action {
      name = "deploy-test-basic"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.test_basic.name}"
      }
    }

    action {
      name = "deploy-test-multi"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.test_multi.name}"
      }
    }
  }

  stage {
    name = "AlphaAndDiscoveryApproval"

    action {
      name = "DeployToAlphaAndDiscoveryProduction"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = "1"
    }
  }

  stage {
    name = "DeployToAlphaAndDiscovery"

    action {
      name = "discovery"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      version = "1"
      input_artifacts = ["openregister_package"]
      run_order = 1

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "discovery"
      }
    }

    action {
      name = "alpha"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      version = "1"
      input_artifacts = ["openregister_package"]
      run_order = 1

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "alpha"
      }
    }

    action {
      name = "deploy-discovery-basic"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.discovery_basic.name}"
      }
    }

    action {
      name = "deploy-discovery-multi"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.discovery_multi.name}"
      }
    }

    action {
      name = "deploy-alpha-basic"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.alpha_basic.name}"
      }
    }

    action {
      name = "deploy-alpha-multi"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.alpha_multi.name}"
      }
    }
  }

  stage {
    name = "BetaApproval"

    action {
      name = "DeployToBeta"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = "1"
    }
  }

  stage {
    name = "DeployToBeta"

    action {
      name = "beta"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      version = "1"
      input_artifacts = ["openregister_package"]
      run_order = 1

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "beta"
      }
    }

    action {
      name = "deploy-beta-basic"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.beta_basic.name}"
      }
    }

    action {
      name = "deploy-beta-multi"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["openregister_package"]
      version = "1"
      run_order = 2

      configuration {
        ProjectName = "${module.beta_multi.name}"
      }
    }
  }
}
