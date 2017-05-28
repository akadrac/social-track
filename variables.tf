variable "region" {
  default = "ap-southeast-2"
}

variable "bucket" {
  default = "social-track"
}

// this will fetch our account_id, no need to hard code it
data "aws_caller_identity" "current" {}

output "function_name" {
  value = "${aws_lambda_function.social_track.function_name}"
}

output "key_id" {
  value = "${aws_kms_key.social_track.key_id}"
}
