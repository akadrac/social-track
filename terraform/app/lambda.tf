resource "aws_lambda_function" "social_track" {
  function_name = "social_track"
  handler = "index.handler"

  filename = "${var.lambda_zip}"
  source_code_hash = "${base64sha256(file("${var.lambda_zip}"))}"

  role = "${aws_iam_role.social_track.arn}"
  memory_size = "128"
  runtime = "nodejs6.10"
  publish = true
  timeout = 15

  kms_key_arn = "${data.terraform_remote_state.base.kms_arn}"

  environment {
    variables = {
      bucket = "${data.terraform_remote_state.base.s3_bucket}",
      region = "${var.region}",
      secrets = "${data.terraform_remote_state.base.s3_file}",
      table = "${aws_dynamodb_table.social_track.name}"
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
  }
}

resource "aws_lambda_alias" "social_track" {
  name             = "social_track"
  function_name    = "${aws_lambda_function.social_track.arn}"
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "social_track" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.social_track.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.social_track.arn}"
}