resource "aws_cloudwatch_log_group" "social_track" {
  name = "/aws/lambda/social_track"
  retention_in_days = 90

  tags {
    Name = "social_track"
    Environment = "production"
  }
}
