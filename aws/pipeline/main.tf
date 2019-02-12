terraform {
  required_version = "~> 0.11.8"
  backend "s3" {
    bucket  = "registers-terraform-state"
    key = "pipeline.tfstate"
    region = "eu-west-1"
    encrypt = "true"
  }
}

provider "aws" {
  profile = "registers"
  version = "~> 1.37"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_kms_alias" "paas_deploy" { name = "alias/paas-deploy" }
