output "iam_role_arn" {
  value       = aws_iam_role.lambda.arn
  description = "ARN of iam role for lambda"
}

output "iam_role_name" {
  value       = aws_iam_role.lambda.name
  description = "Name of iam role for lambda"
}

output "iam_policy_arn" {
  value = aws_iam_policy.lambda_logging.arn
  description = "ARN of iam policy"
}
