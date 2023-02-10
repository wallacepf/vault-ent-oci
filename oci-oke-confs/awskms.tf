

data "aws_iam_policy_document" "vault-kms-unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = [aws_kms_key.vault.arn]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

resource "aws_iam_user_policy" "vault-kms-unseal" {
  name   = "Vault-KMS-Unseal-${random_pet.env.id}"
  user   = aws_iam_user.vault-unseal.id
  policy = data.aws_iam_policy_document.vault-kms-unseal.json
}

resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 10

  tags = {
    Name = "vault-kms-unseal-${random_pet.env.id}"
  }
}

resource "aws_iam_user" "vault-unseal" {
  name = "vault-unseal"
}

resource "aws_iam_access_key" "vault-unseal" {
  user = aws_iam_user.vault-unseal.name
}

resource "random_pet" "env" {
  length    = 2
  separator = "_"
}