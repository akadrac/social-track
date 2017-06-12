resource "aws_iam_role" "role" {
  name = "social_track_frontend_lambda_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "frontend_policy" {
  statement {
    actions   = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.frontend.bucket}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.frontend_origin_id.iam_arn}"]
    }
  }

  statement {
    actions   = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.frontend.bucket}"
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.frontend_origin_id.iam_arn}"]
    }
  }
}

data "aws_iam_policy_document" "social_track_get" {
  statement {
    actions = [
      "dynamodb:Scan"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${data.terraform_remote_state.backend.table_name}"
    ]
  } 
}

resource "aws_iam_policy" "social_track_get" {
  name = "social_track_get"
  path = "/"
  policy = "${data.aws_iam_policy_document.social_track_get.json}"
}

resource "aws_iam_role_policy_attachment" "social_track" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.social_track_get.arn}"
}