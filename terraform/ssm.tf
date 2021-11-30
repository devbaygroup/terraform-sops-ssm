##########################
# KMS key for SOPs
##########################
resource "aws_kms_key" "sops" {
  description = "Keys to decrypt SOPS encrypted values"
}
resource "aws_kms_alias" "sops" {
  name          = "alias/sops"
  target_key_id = aws_kms_key.sops.key_id
}

##########################
# Create SSM secrets
##########################
locals {
  secrets = toset([
    "db-foo",
  ])
}

data "sops_file" "sops_secrets" {
  for_each    = local.secrets
  source_file = "secrets/${each.key}.sops.json"
}
# aws keeps the secrets for 7 days before actual deletion. consider using random names during test
resource "aws_secretsmanager_secret" "ssm_secrets" {
  for_each = local.secrets
  name     = each.key
}
resource "aws_secretsmanager_secret_version" "ssm_secrets" {
  for_each      = local.secrets
  secret_id     = aws_secretsmanager_secret.ssm_secrets["${each.key}"].id
  secret_string = jsonencode(data.sops_file.sops_secrets["${each.key}"].data)
}
