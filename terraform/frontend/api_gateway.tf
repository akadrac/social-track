# API Gateway
# resource "aws_api_gateway_rest_api" "api" {
#   name = "myapi"

#   tags {
#     Name = "social_track"
#     Environment = "production"
#     Component = "frontend"
#     Managed = "terraform"
#   }
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
#   resource_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
#   resource_id             = "${aws_api_gateway_rest_api.api.root_resource_id}"
#   http_method             = "${aws_api_gateway_method.method.http_method}"
#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
# }
