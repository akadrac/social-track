terraform {
  backend "s3" {
    bucket = "akadrac-terraform-state"
    key = "social/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  profile = "default"
  region = "${var.region}"
}

resource "aws_iam_role" "social_track" {
  name = "social_track"
  assume_role_policy = "${file("policies/social.json")}"
}

data "aws_iam_policy_document" "social_track" {
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:*",
    ]
  }

  statement {
    actions = [
      "dynamodb:Scan",
      "dynamodb:PutItem"
    ]

    resources = [
      "*",
    ]
  } 

  statement {
    actions = [
      "kms:Decrypt"
    ]

    resources = [
      "*",
    ]
  } 
}

resource "aws_iam_policy" "social_track" {
  name = "social_track"
  path = "/"
  policy = "${data.aws_iam_policy_document.social_track.json}"
}

resource "aws_iam_role_policy_attachment" "social_track" {
  role       = "${aws_iam_role.social_track.name}"
  policy_arn = "${aws_iam_policy.social_track.arn}"
}

resource "aws_lambda_alias" "social_track" {
  name             = "social_track"
  function_name    = "${aws_lambda_function.social_track.arn}"
  function_version = "$LATEST"
}

resource "aws_lambda_function" "social_track" {
  function_name = "social_track"
  handler = "index.handler"

  filename = "dist/app.zip"
  source_code_hash = "${base64sha256(file("dist/app.zip"))}"

  role = "${aws_iam_role.social_track.arn}"
  memory_size = "128"
  runtime = "nodejs6.10"
  publish = true
  timeout = 15

  tags {
    Name = "social_track"
    Environment = "production"
  }
}

resource "aws_cloudwatch_event_rule" "social_track" {
  name = "social_track"
  description = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "social_track" {
  rule = "${aws_cloudwatch_event_rule.social_track.name}"
  target_id = "social_track"
  arn = "${aws_lambda_function.social_track.arn}"
}

resource "aws_lambda_permission" "social_track" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.social_track.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.social_track.arn}"
}

resource "aws_dynamodb_table" "social_track" {
  name = "social_track"
  hash_key = "screen_name"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "screen_name"
    type = "S"
  }

  tags {
    Name = "social_track"
    Environment = "production"
  }
}

# resource "aws_cloudwatch_log_group" "social_track" {
#   name = "social_track"
#   retention_in_days = 90

#   tags {
#     Name = "social_track"
#     Environment = "production"
#   }
# }