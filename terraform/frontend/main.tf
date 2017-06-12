terraform {
  backend "s3" {
    bucket = "akadrac-terraform-state"
    key = "social/frontend.tfstate"
    region = "ap-southeast-2"
    encrypt = true
    #lock_table = "terraform-lock" # primary key == LockID
  }
}

provider "aws" {
  profile = "default"
  region = "${var.region}"
}

#hack to support issued certs out of us-east-1 only
provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

variable "region" {
  default = "ap-southeast-2"
}

// this will fetch our account_id, no need to hard code it
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "backend" {
    backend = "s3"
    config {
        bucket = "akadrac-terraform-state"
        key = "social/backend.tfstate"
        region = "ap-southeast-2"
    }
}