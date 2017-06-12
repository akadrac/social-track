resource "aws_api_gateway_rest_api" "api" {
  name = "social-track"
}

resource "aws_api_gateway_resource" "names" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "names"
}

module "get" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.names.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.names.path}"
  lambda      = "${aws_lambda_function.get.function_name}"
  region      = "${var.region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

module "delete" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.names.id}"
  method      = "DELETE"
  path        = "${aws_api_gateway_resource.names.path}"
  lambda      = "${aws_lambda_function.delete.function_name}"
  region      = "${var.region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# resource "aws_api_gateway_deployment" "api" {
#   rest_api_id = "${aws_api_gateway_rest_api.api.id}"
#   stage_name  = "production"
#   description = ""
# }