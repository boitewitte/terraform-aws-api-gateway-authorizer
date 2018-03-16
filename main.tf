module "label" {
  source                  = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace               = "${var.namespace}"
  stage                   = "${var.environment}"
  name                    = "${var.name}"
  tags                    = "${var.tags}"
}

resource "aws_api_gateway_authorizer" "this" {
  name                    = "${module.label.id}"
  rest_api_id             = "${var.api_id}"
  
  authorizer_uri          = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer.arn}/invocations"
  authorizer_credentials  = "${aws_iam_role.invocation_role.arn}"

  identity_source         = "method.request.header.Authorization"
  identity_validation_expression = "^Bearer .*$"

  authorizer_result_ttl_in_seconds = "3600"
}

resource "aws_iam_role" "invocation_role" {
  name                    = "${module.label.id}-invocation"
  path                    = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "apigateway.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name                    = "${module.label.id}-invocation-policy"
  role                    = "${aws_iam_role.invocation_role.id}"

  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.authorizer.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "execution_role" {
  name                    = "${module.label.id}-execution"

  assume_role_policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "network-attachment" {
  role                 = "${aws_iam_role.execution_role.name}"

  policy_arn           = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "authorizer" {
  function_name           = "${module.label.id}"

  filename                = "${var.filename}"
  source_code_hash        = "${base64sha256(file(var.filename))}"

  handler                 = "${var.handler}"
  runtime                 = "${var.runtime}"
  memory_size             = "${var.memory_size}"
  timeout                 = "${var.timeout}"

  role                    = "${aws_iam_role.execution_role.arn}"

  tags                    = "${module.label.tags}"

  environment             = {
    variables             = "${merge(module.label.tags, var.environment_variables)}"
  }

  vpc_config              = {
    subnet_ids              = ["${var.vpc_subnet_ids}"]
    security_group_ids      = ["${var.vpc_security_group_ids}"]
  }
}
