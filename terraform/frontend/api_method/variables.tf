variable "rest_api_id" {
  description = "The ID of the associated REST API"
}

variable "resource_id" {
  description = "The API resource ID"
}

variable "method" {
  description = "The HTTP method"
  default     = "GET"
}

variable "path" {
  description = "The API resource path"
}

variable "lambda" {
  description = "The lambda name to invoke"
}

variable "region" {
  description = "The AWS region, e.g., eu-west-1"
}

variable "account_id" {
  description = "The AWS account ID"
}

variable "integration_request_template" {
  default = "#set($inputRoot = $input.path('$')){}"
}

variable "integration_response_template" {
  default = "#set($inputRoot = $input.path('$')){}"
}

variable "integration_error_template" {
  default = <<EOF
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')) {
  "message" : "$errorMessageObj.message"
}
EOF
}

variable "request_model" {
  default = "Empty"
}

variable "response_model" {
  default = "Empty"
}
