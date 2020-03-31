# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE ALL RESOURCES RELATED TO TW LAMBDA, SUCH AS S3, IAM, CLOUD WATCH ,ETC..
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS REGION
# ------------------------------------------------------------------------------
provider "aws" {
  region = var.region
}

# ------------------------------------------------------------------------------
# LOAD IAM MOUDLE
# ------------------------------------------------------------------------------
module "lambda_iam" {
  source = "../iam"
}

# ------------------------------------------------------------------------------
# LAMBDA FUNCTION RESOURCE
# ------------------------------------------------------------------------------
resource "aws_lambda_function" "lambda_function" {
  filename      = "lambda.zip"
  function_name = "tw-lambda"
  role          = module.lambda_iam.iam_role_arn
  handler       = "handler"
  source_code_hash = filebase64sha256("lambda.zip")
  runtime = "nodejs12.x"
  timeout = var.timeout
  memory_size = var.memory_size
  environment {
    variables = var.environment_variables
  }
}

# ------------------------------------------------------------------------------
# Define cloud watch event rule.
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "cloudwatch_schedule" {
  name = "cloudwatch_schedule"
  description = "Schedule for invoking"
  schedule_expression = "rate(6 hours)"
}

# ------------------------------------------------------------------------------
# Define cloud watch event target.
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "cloudwatch_schedule" {
  rule = aws_cloudwatch_event_rule.cloudwatch_schedule.name
  target_id = "tw_cloudwatch_schedule"
  arn = aws_lambda_function.lambda_function.arn
  input = <<DOC
  {
    "path": "./users/index",
    "body": {
      "screenNames": [
        "chenqiushi404", "realDonaldTrump", "AlboMP", "KatieAllenMP", "karenandrewsmp", "kevinandrewsmp", "bridgetarcher", "AdamBandt", "SharonBirdMP", "BroadbentMP", "ScottBuchholzMP", "Tony_Burke"
      ]
    }
  }
  DOC
}
