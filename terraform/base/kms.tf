resource "aws_kms_key" "social_track" {
  description = "social_track lambda secrets"
  is_enabled = true
}

resource "aws_kms_alias" "social_track" {
  name          = "alias/social_track"
  target_key_id = "${aws_kms_key.social_track.key_id}"
}