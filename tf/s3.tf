resource "aws_s3_bucket" "lambda" {
  bucket = "akadrac-lambda"
  acl    = "private"

  tags = {
    Name = "social_track"
    Environment = "production"
  }
}