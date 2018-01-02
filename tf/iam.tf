resource "aws_iam_role" "social_track" {
  name = "social_track"
  assume_role_policy = "${file("policies/social.json")}"
}

data "aws_iam_policy_document" "social_track" {
  statement {
    actions = [
      "dynamodb:Scan",
      "dynamodb:PutItem"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.social_track.name}"
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

resource "aws_iam_role_policy_attachment" "basic_lambda" {
  role       = "${aws_iam_role.social_track.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
