##########################
# SSM access
##########################
data "aws_iam_policy_document" "secrets_ro" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      "arn:aws:secretsmanager:ap-southeast-1:$AWS_ACCOUNT_ID:secret:*",
    ]
  }
  statement {
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "secrets_ro" {
  name   = "secrets_ro"
  path   = "/"
  policy = data.aws_iam_policy_document.secrets_ro.json
}
