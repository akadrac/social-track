resource "aws_iam_role" "social_track" {
  name = "social_track"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

resource "aws_lambda_function" "social_track" {
  filename = "dist/app.zip"
  function_name = "social_track"
  role = "${aws_iam_role.social_track.arn}"
  handler = "index.handler"
  runtime = "nodejs6.10"
  source_code_hash = "${base64sha256(file("dist/app.zip"))}"
  publish = true
}

resource "aws_cloudwatch_event_rule" "social_track" {
    name = "social_track"
    description = "Fires every five minutes"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
    rule = "${aws_cloudwatch_event_rule.social_track.name}"
    target_id = "social_track"
    arn = "${aws_lambda_function.social_track.arn}"
}