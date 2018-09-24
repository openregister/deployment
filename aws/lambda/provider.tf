provider "aws" {
  version = "~> 1.37"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "archive" {
  version = "~> 1.1"
}
