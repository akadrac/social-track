resource "aws_lambda_function" "social_track" {
  function_name = "social_track"
  handler = "index.handler"

  filename = "${var.lambda_zip}"
  source_code_hash = "${base64sha256(file("${var.lambda_zip}"))}"

  role = "${aws_iam_role.social_track.arn}"
  memory_size = "128"
  runtime = "nodejs10.x"
  publish = true
  timeout = 15
  reserved_concurrent_executions = 1

  environment {
    variables = {
      region = "${var.region}",
      table = "${aws_dynamodb_table.social_track.name}",
      consumer_key = "${var.consumer_key}",
      consumer_secret = "${var.consumer_secret}",
      access_token_key = "${var.access_token_key}",
      access_token_secret = "${var.access_token_secret}",
      webhook = "${var.webhook}"
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