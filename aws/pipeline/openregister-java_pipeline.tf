resource "aws_iam_role" "codepipeline" {
  name = "codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "codepipeline.amazonaws.com"
    }
  }]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "codepipeline"
  role = "${aws_iam_role.codepipeline.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Resource": "arn:aws:s3:::codepipeline*",
    "Effect": "Allow",
    "Action": "s3:PutObject"
  }, {
    "Resource": "*",
    "Effect": "Allow",
    "Action": [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
      "iam:PassRole",
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning"
    ]
  }]
}
EOF
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

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "test"
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

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "alpha"
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

      configuration {
        ApplicationName = "openregister-app"
        DeploymentGroupName = "beta"
      }
    }
  }
}
