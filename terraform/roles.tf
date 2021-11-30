####################################
# github actions with OIDC
####################################
locals {
  repositories = [
    "terraform-sops-ssm",
  ]
}
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
}
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for v in local.repositories : "repo:kahnwong/${v}:*"]
    }
  }
}
resource "aws_iam_role" "playground-prod-github" {
  name = "playground-prod-github"
  path = "/sa/"

  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  managed_policy_arns = [
    aws_iam_policy.secrets_ro.arn,
  ]
}

####################################
# lambda
####################################
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  path = "/sa/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.secrets_ro.arn,
  ]

  inline_policy {
    name = "create_cloudwatch_logs"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
      ]
    })
  }
}
