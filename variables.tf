variable "region" {
  default = "ap-southeast-2"
}

// this will fetch our account_id, no need to hard code it
data "aws_caller_identity" "current" {}