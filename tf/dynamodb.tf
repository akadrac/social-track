resource "aws_dynamodb_table" "social_track" {
  name = "social_track"
  hash_key = "screen_name"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "screen_name"
    type = "S"
  }

  tags = {
    Name = "social_track"
    Environment = "production"
  }
}