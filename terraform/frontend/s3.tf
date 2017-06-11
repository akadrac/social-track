resource "aws_s3_bucket" "frontend" {
  bucket = "${var.bucket}"
  acl    = "private"

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = "${aws_s3_bucket.frontend.id}"
  policy = "${data.aws_iam_policy_document.frontend_policy.json}"
}

data "template_file" "main" {
    template = <<EOF
aws s3 sync --acl private ../../frontend/client/build/ s3://${aws_s3_bucket.frontend.bucket} --delete
EOF
}

resource "null_resource" "main" {
  triggers {
    rendered_template = "${data.template_file.main.rendered}"
    version = "${var.version}"
  }

  provisioner "local-exec" {
    command = "${data.template_file.main.rendered}"
  }
}