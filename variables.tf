variable "region" {
  default = "us-west-2"
}

provider "aws" {
    profile = "default"
    region = "${var.region}"
}

// this will fetch our account_id, no need to hard code it
data "aws_caller_identity" "current" {}