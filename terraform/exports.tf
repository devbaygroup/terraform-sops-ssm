output "secret_ids" {
  value = tomap({
    for k, v in aws_secretsmanager_secret.ssm_secrets : k => v.id
  })
}

output "role_arns" {
  value = {
    "playground-prod-github_arn" = aws_iam_role.playground-prod-github.arn
    "lambda_role_arn"            = aws_iam_role.lambda_role.arn
  }
}

output "users" {
  value = {
    "playground-prod-dev_key" : aws_iam_access_key.playground-prod-dev.id
    "playground-prod-dev_secret" : aws_iam_access_key.playground-prod-dev.secret
  }
  sensitive = true
}
