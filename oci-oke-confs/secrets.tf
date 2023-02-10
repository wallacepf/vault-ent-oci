resource "kubernetes_secret" "aws-creds" {
  metadata {
    name      = "aws-creds"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.vault-unseal.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.vault-unseal.secret
  }
}

resource "kubernetes_secret" "aws-region" {
  metadata {
    name      = "aws-region-info"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    AWS_REGION = var.aws_region
  }

}

resource "kubernetes_secret" "aws-kms-seal-key" {
  metadata {
    name      = "aws-sealkey-id"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    VAULT_AWSKMS_SEAL_KEY_ID = aws_kms_key.vault.key_id
  }

}

resource "kubernetes_secret" "vault-license" {
  metadata {
    name      = "vault-license"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    "license.hclic" = var.vault_license
  }

}


resource "kubernetes_secret" "vault-server-tls" {
  metadata {
    name      = "vault-server-tls"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  type = "generic"

  data = {
    "vault.key" = trimspace(tls_private_key.vault-key.private_key_pem)
    "vault.crt" = trimspace(tls_locally_signed_cert.vault-cert.cert_pem)
    "ca.pem"    = trimspace(tls_self_signed_cert.ca-sign.cert_pem)
  }

}

resource "kubernetes_secret" "dockercreds" {
  metadata {
    name = "dockercreds"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = templatefile(
      "config.json",
      {
        docker-username = "${var.docker_creds.docker_user}",
        docker-password = "${var.docker_creds.docker_password}",
        docker-server   = "${var.docker_creds.docker_server}",
        docker-email    = "${var.docker_creds.docker_email}",
        auth            = base64encode("${var.docker_creds.docker_user}:${var.docker_creds.docker_password}")
      }
    )
  }

  type = "kubernetes.io/dockerconfigjson"
}