resource "aws_s3_bucket" "lambda" {
  bucket = "akadrac-lambda"

  tags = {
    Name        = "social_track"
    Environment = "production"
  }
}

resource "aws_s3_bucket_acl" "lambda" {
  bucket = aws_s3_bucket.lambda.id
  acl    = "private"
}
