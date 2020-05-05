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
  source_code_hash = data.aws_s3_bucket_object.zip_hash.body
  runtime = "nodejs12.x"
  timeout = var.timeout
  memory_size = var.memory_size
  environment {
    variables = var.environment_variables
  }
}
# ------------------------------------------------------------------------------
# Define cloud watch event rule for trends available.
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "tw_syncer_event_rule_trends_available" {
  name = "cloudwatch_schedule"
  description = "Schedule for invoking trends available"
  schedule_expression = var.trends_available_schedule_expression
}

# ------------------------------------------------------------------------------
# Define cloud watch event target for trends available.
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "tw_syncer_event_target_trends_available" {
  rule = aws_cloudwatch_event_rule.tw_syncer_event_rule_trends_available.name
  target_id = "tw_cloudwatch_schedule_trends_available"
  arn = aws_lambda_function.tw_syncer_function.arn
  input = <<DOC
  {
    "path": "trends/available"
  }
  DOC
}

# ------------------------------------------------------------------------------
# Setup lambda permissions with cloud watch allow trends available cloud watch event to call lambda.
# ------------------------------------------------------------------------------
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_trends_available" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tw_syncer_function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.tw_syncer_event_rule_trends_available.arn
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
    "path": "users/lookup",
    "body": {
      "screen_name": [
        "BarackObama",
        "realDonaldTrump",
        "Schwarzenegger",
        "SenSanders",
        "BillClinton",
        "SenWarren",
        "SecretaryCarson",
        "SpeakerPelosi",
        "GovMikeHuckabee",
        "tedcruz",
        "JohnKerry",
        "KamalaHarris",
        "GabbyGiffords",
        "Mike_Pence",
        "RepAdamSchiff",
        "alfranken",
        "SenSchumer",
        "newtgingrich",
        "AndrewYang",
        "PeteButtigieg",
        "CoryBooker",
        "NikkiHaley",
        "SenatorDole",
        "SarahPalinUSA",
        "RonPaul",
        "TulsiGabbard",
        "TGowdySC",
        "JulianCastro",
        "SenFeinstein",
        "LindseyGrahamSC",
        "JerryBrownGov",
        "SenGillibrand",
        "senatemajldr",
        "SenDuckworth",
        "AllenWest",
        "SteveScalise",
        "RBReich",
        "donnabrazile",
        "timkaine",
        "JoeBiden",
        "ewarren",
        "WhiteHouse",
        "HillaryClinton",
        "MrKRudd",
        "JuliaGillard",
        "HonTonyAbbott",
        "ScottMorrisonMP",
        "billshortenmp",
        "DarrynLyons",
        "HonJulieBishop",
        "SenatorWong",
        "tanya_plibersek"
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

# ------------------------------------------------------------------------------
# Setup cloudwatch event rule for all timelines
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "tw_syncer_event_rule_user_timelines" {
  for_each = {for timeline in var.timelines: timeline.screen_name => timeline}
  name = each.key
  schedule_expression = each.value.schedule_expression
}

# ------------------------------------------------------------------------------
# Setup cloudwatch event target for user timelines
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "tw_syncer_event_target_user_timelines" {
  for_each = {for timeline in var.timelines: timeline.screen_name => timeline}
  rule = aws_cloudwatch_event_rule.tw_syncer_event_rule_user_timelines[each.key].name
  arn = aws_lambda_function.tw_syncer_function.arn
  input = <<DOC
  {
    "path": "tweets/timeline",
    "body": {
      "screen_name": "${each.key}"
    }
  }
  DOC
}

# ------------------------------------------------------------------------------
# Setup permissions for timelines
# ------------------------------------------------------------------------------
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_user_timelines" {
  for_each = {for timeline in var.timelines: timeline.screen_name => timeline}
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tw_syncer_function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.tw_syncer_event_rule_user_timelines[each.key].arn
}



# ------------------------------------------------------------------------------
# Setup cloudwatch event rule for trends places
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "tw_syncer_event_rule_trends_places" {
  for_each = {for place in var.places: place.id => place}
  name = each.key
  schedule_expression = each.value.schedule_expression
}

# ------------------------------------------------------------------------------
# Setup cloudwatch event target for user timelines
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_event_target" "tw_syncer_event_target_trends_places" {
  for_each = {for place in var.places: place.id => place}
  rule = aws_cloudwatch_event_rule.tw_syncer_event_rule_trends_places[each.key].name
  arn = aws_lambda_function.tw_syncer_function.arn
  input = <<DOC
  {
    "path": "trends/place",
    "body": {
      "id": "${each.key}"
    }
  }
  DOC
}

# ------------------------------------------------------------------------------
# Setup permissions for trends places
# ------------------------------------------------------------------------------
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_trends_places" {
  for_each = {for place in var.places: place.id => place}
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tw_syncer_function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.tw_syncer_event_rule_trends_places[each.key].arn
}
