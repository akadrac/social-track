output "s3_bucket" {
  value = "${aws_s3_bucket.social_track.bucket}"
}

output "s3_file" {
  value = "${aws_s3_bucket_object.social_track.key}"
}

output "kms_key" {
  value = "${aws_kms_key.social_track.key_id}"
}

output "kms_arn" {
  value = "${aws_kms_key.social_track.arn}"
}

output "kms_alias" {
  value = "${aws_kms_alias.social_track.name}"
}