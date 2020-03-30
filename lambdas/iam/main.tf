# ------------------------------------------------------------------------------
# IAM ASSUME ROLE POLICY FOR LAMBDA
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ------------------------------------------------------------------------------
# IAM ROLE FOR LAMBDA
# ------------------------------------------------------------------------------
resource "aws_iam_role" "lambda" {
  name = "lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# ------------------------------------------------------------------------------
# IAM POLICY FOR LOGGING
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# ------------------------------------------------------------------------------
# ATTACH POLICY TO ROLE FOR LOGS
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_iam_role_policy_attachment" {
  role = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
