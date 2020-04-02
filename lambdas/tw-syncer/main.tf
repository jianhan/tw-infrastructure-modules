# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE ALL RESOURCES RELATED TO TW LAMBDA, SUCH AS S3, IAM, CLOUD WATCH ,ETC..
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = var.backend_s3_bucket_name
    key            = var.backend_s3_key
    region         = var.backend_s3_region
    dynamodb_table = var.backend_s3_dynamodb_table
    encrypt        = true
  }
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

data "aws_s3_bucket_object" "zip_hash" {
  bucket = var.lambda_function_s3_bucket
  key    = var.lambda_function_s3_key
}

# ------------------------------------------------------------------------------
# LAMBDA FUNCTION RESOURCE
# ------------------------------------------------------------------------------
resource "aws_lambda_function" "tw_syncer_function" {
  s3_bucket = var.lambda_function_s3_bucket
  s3_key = var.lambda_function_s3_key
  function_name = "tw-syncer-lambda"
  role          = module.lambda_iam.iam_role_arn
  handler       = "index.handler"
//  source_code_hash = filebase64sha256(var.lambda_function_s3_key)
  source_code_hash =data.aws_s3_bucket_object.zip_hash.body
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
resource "aws_cloudwatch_event_rule" "tw_syncer_event_rule" {
  name = "cloudwatch_schedule"
  description = "Schedule for invoking"
  schedule_expression = var.schedule_expression
}

# ------------------------------------------------------------------------------
# Define cloud watch event target.
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "tw_syncer_event_target" {
  rule = aws_cloudwatch_event_rule.tw_syncer_event_rule.name
  target_id = "tw_cloudwatch_schedule"
  arn = aws_lambda_function.tw_syncer_function.arn
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

# ------------------------------------------------------------------------------
# Setup lambda permissions with cloud watch.
# ------------------------------------------------------------------------------
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tw_syncer_function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.tw_syncer_event_rule.arn
}
