terraform {
  required_version = "~> 0.9.0"
  backend "s3" {
    bucket  = "registers-certs-terraform-state"
    key = "tls-certs.tfstate"
    region = "eu-west-1"
    encrypt = "true"
  }
}
