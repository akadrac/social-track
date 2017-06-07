data "archive_file" "get" {
  type        = "zip"
  source_file = "frontend/functions/get.js"
  output_path = "dist/get.zip"
}

resource "aws_lambda_function" "get" {
  filename         = "dist/get.zip"
  function_name    = "get"
  role             = "${aws_iam_role.role.arn}"
  handler          = "get.handler"
  runtime          = "node6.10"
  source_code_hash = "${base64sha256(data.archive_file.get.output_path)}"
}

data "archive_file" "post" {
  type        = "zip"
  source_file = "frontend/functions/post.js"
  output_path = "dist/post.zip"
}

resource "aws_lambda_function" "post" {
  filename         = "dist/post.zip"
  function_name    = "post"
  role             = "${aws_iam_role.role.arn}"
  handler          = "post.handler"
  runtime          = "node6.10"
  source_code_hash = "${base64sha256(data.archive_file.post.output_path)}"
}

data "archive_file" "put" {
  type        = "zip"
  source_file = "frontend/functions/put.js"
  output_path = "dist/put.zip"
}

resource "aws_lambda_function" "put" {
  filename         = "dist/put.zip"
  function_name    = "put"
  role             = "${aws_iam_role.role.arn}"
  handler          = "put.handler"
  runtime          = "node6.10"
  source_code_hash = "${base64sha256(data.archive_file.put.output_path)}"
}

data "archive_file" "patch" {
  type        = "zip"
  source_file = "frontend/functions/patch.js"
  output_path = "dist/patch.zip"
}

resource "aws_lambda_function" "patch" {
  filename         = "dist/patch.zip"
  function_name    = "patch"
  role             = "${aws_iam_role.role.arn}"
  handler          = "patch.handler"
  runtime          = "node6.10"
  source_code_hash = "${base64sha256(data.archive_file.patch.output_path)}"
}

data "archive_file" "delete" {
  type        = "zip"
  source_file = "frontend/functions/delete.js"
  output_path = "dist/delete.zip"
}

resource "aws_lambda_function" "delete" {
  filename         = "dist/delete.zip"
  function_name    = "delete"
  role             = "${aws_iam_role.role.arn}"
  handler          = "delete.handler"
  runtime          = "node6.10"
  source_code_hash = "${base64sha256(data.archive_file.delete.output_path)}"
}

# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.lambda.arn}"
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}/resourcepath/subresourcepath"
# }