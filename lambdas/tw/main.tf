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
  filename      = "tw_lambda.zip"
  function_name = "tw_lambda"
  role          = module.lambda_iam.iam_role_arn
  handler       = "handler"
  source_code_hash = filebase64sha256("tw_lambda.zip")
  runtime = "nodejs12.x"
  timeout = var.timeout
  memory_size = var.memory_size
  environment {
    variables = var.environment_variables
  }
}
