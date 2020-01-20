terraform {
  required_version = "~> 0.11.8"
  backend "s3" {
    bucket = "registers-terraform-state"
    key = "account-wide.tfstate"
    region = "eu-west-1"
    encrypt = "true"
  }
}
