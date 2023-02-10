resource "tls_private_key" "vault-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca-sign" {
  private_key_pem   = tls_private_key.ca.private_key_pem
  is_ca_certificate = true

  subject {
    common_name  = "ca-root"
    organization = "Hashicorp SE Org"
  }

  validity_period_hours = 43800

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

resource "tls_cert_request" "vault-crt" {
  private_key_pem = tls_private_key.vault-key.private_key_pem

  subject {
    common_name  = "vault-tls"
    organization = "Hashicorp SE Org"
  }

  dns_names = [
    "*.vault-internal",
    "vault",
    "vault.vault",
    "vault.vault.svc",
    "vault.vault.svc.cluster.local",
    "vault-internal",
    "vault-tls",
    "*.vault.svc.cluster.local",
    "*.vault-dr.svc.cluster.local",
    "*.vault-pr.svc.cluster.local"
  ]

  ip_addresses = ["127.0.0.1"]
}

resource "tls_locally_signed_cert" "vault-cert" {
  cert_request_pem   = tls_cert_request.vault-crt.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-sign.cert_pem

  validity_period_hours = 768

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}