resource "aws_s3_bucket" "social_track" {
  bucket = "${var.bucket}"
  acl = "private"
}

resource "aws_s3_bucket_object" "social_track" {
  key = "encrypted-secrets"
  bucket = "${aws_s3_bucket.social_track.bucket}"
  content = "${base64decode(data.aws_kms_ciphertext.social_track.ciphertext_blob)}"
}

data "aws_kms_ciphertext" "social_track" {
  key_id = "${aws_kms_key.social_track.key_id}"
  plaintext = "${file("../../secrets/keys.json")}"
}