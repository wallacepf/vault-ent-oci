resource "vault_policy" "jenkins-vault-poc" {
  name = "jenkins-vault-poc"

  policy = <<EOT
path "secrets/data/vault-poc" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_policy" "gha-vault-poc" {
  name = "gha-vault-poc"

  policy = <<EOT
path "secrets/data/gha/*" {
  capabilities = ["read", "list"]
}

path "postgres/creds/readonly" {
    capabilities = ["read"]
}
EOT
}

resource "vault_policy" "vaulidate-file" {
  name = "vaulidate-file"

  policy = <<EOT
path "postgres/creds/readonly" {
    capabilities = ["read"]
}

path "secrets/data/gha/*" {
  capabilities = ["read", "list"]
}

path "secrets/data/vaulidate/mysecret" {
  capabilities = ["read"]
}
EOT
}