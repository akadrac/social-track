data "archive_file" "get" {
  type        = "zip"
  source_file = "../../frontend/functions/get.js"
  output_path = "../../dist/get.zip"
}

resource "aws_lambda_function" "get" {
  filename         = "../../dist/get.zip"
  function_name    = "social_track_get"
  role             = "${aws_iam_role.role.arn}"
  handler          = "get.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${data.archive_file.get.output_base64sha256}"

  environment {
    variables = {
      region = "${var.region}",
      table = "${data.terraform_remote_state.backend.table_name}"
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }
}

data "archive_file" "post" {
  type        = "zip"
  source_file = "../../frontend/functions/post.js"
  output_path = "../../dist/post.zip"
}

resource "aws_lambda_function" "post" {
  filename         = "../../dist/post.zip"
  function_name    = "social_track_post"
  role             = "${aws_iam_role.role.arn}"
  handler          = "post.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${data.archive_file.post.output_base64sha256}"

  environment {
    variables = {
      region = "${var.region}",
      table = "${data.terraform_remote_state.backend.table_name}"
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }
}

data "archive_file" "put" {
  type        = "zip"
  source_file = "../../frontend/functions/put.js"
  output_path = "../../dist/put.zip"
}

resource "aws_lambda_function" "put" {
  filename         = "../../dist/put.zip"
  function_name    = "social_track_put"
  role             = "${aws_iam_role.role.arn}"
  handler          = "put.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${data.archive_file.put.output_base64sha256}"

  environment {
    variables = {
      region = "${var.region}",
      table = "${data.terraform_remote_state.backend.table_name}"
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }
}

data "archive_file" "patch" {
  type        = "zip"
  source_file = "../../frontend/functions/patch.js"
  output_path = "../../dist/patch.zip"
}

resource "aws_lambda_function" "patch" {
  filename         = "../../dist/patch.zip"
  function_name    = "social_track_patch"
  role             = "${aws_iam_role.role.arn}"
  handler          = "patch.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${data.archive_file.patch.output_base64sha256}"

  environment {
    variables = {
      region = "${var.region}",
      table = "${data.terraform_remote_state.backend.table_name}"
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }
}

data "archive_file" "delete" {
  type        = "zip"
  source_file = "../../frontend/functions/delete.js"
  output_path = "../../dist/delete.zip"
}

resource "aws_lambda_function" "delete" {
  filename         = "../../dist/delete.zip"
  function_name    = "social_track_delete"
  role             = "${aws_iam_role.role.arn}"
  handler          = "delete.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${data.archive_file.delete.output_base64sha256}"

  environment {
    variables = {
      region = "${var.region}",
      table = "${data.terraform_remote_state.backend.table_name}"
    }
  }

  tags {
    Name = "social_track"
    Environment = "production"
    Component = "frontend"
    Managed = "terraform"
  }
}
