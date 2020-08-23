resource "aws_cloudwatch_event_rule" "social_track" {
  name = "social_track"
  description = "Fires every one minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "social_track" {
  rule = aws_cloudwatch_event_rule.social_track.name
  target_id = "social_track"
  arn = aws_lambda_function.social_track.arn
}