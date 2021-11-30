resource "aws_iam_user" "playground-prod-dev" {
  name = "playground-prod-dev"
  path = "/users/"
}
resource "aws_iam_access_key" "playground-prod-dev" {
  user = aws_iam_user.playground-prod-dev.name
}
resource "aws_iam_user_policy_attachment" "playground-prod-dev" {
  user = aws_iam_user.playground-prod-dev.name

  for_each = toset([
    aws_iam_policy.secrets_ro.arn,
  ])
  policy_arn = each.value
}
