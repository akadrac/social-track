terraform {
  backend "s3" {
    bucket = "akadrac-terraform-state"
    key = "social-track.tfstate"
    region = "ap-southeast-2"
    encrypt = true
    #lock_table = "terraform-lock" # primary key == LockID
  }
}

provider "aws" {
  profile = "default"
  region = var.region
}

variable "region" {
  default = "ap-southeast-2"
}

variable "lambda_zip" {
  default = "../dist/app.zip"
}

// this will fetch our account_id, no need to hard code it
data "aws_caller_identity" "current" {}
