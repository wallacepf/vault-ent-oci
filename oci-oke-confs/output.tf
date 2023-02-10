output "secret_key" {
  value     = aws_iam_access_key.vault-unseal.secret
  sensitive = true
}

output "access_key" {
  value = aws_iam_access_key.vault-unseal.id
}

output "vault_server_crt" {
  value     = trimspace(tls_locally_signed_cert.vault-cert.cert_pem)
  sensitive = true
}

output "vault_server_key" {
  value     = trimspace(tls_private_key.vault-key.private_key_pem)
  sensitive = true
}

output "vault_ca_cert" {
  value     = trimspace(tls_self_signed_cert.ca-sign.cert_pem)
  sensitive = true
}