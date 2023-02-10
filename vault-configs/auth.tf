resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = "https://kubernetes.default.svc.cluster.local"
}

resource "vault_kubernetes_auth_backend_role" "vaulidate-file" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vaulidate-file"
  bound_service_account_names      = ["vaulidate-file"]
  bound_service_account_namespaces = ["vaulidate-file"]
  token_ttl                        = 3600
  token_policies                   = ["default", "vaulidate-file"]
}

resource "vault_kubernetes_auth_backend_role" "vaulidate-native" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vaulidate-native"
  bound_service_account_names      = ["vaulidate-native"]
  bound_service_account_namespaces = ["vaulidate-native"]
  token_ttl                        = 3600
  token_policies                   = ["default", "vaulidate-file"]
}

resource "vault_kubernetes_auth_backend_role" "vaulidate-env" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vaulidate-env"
  bound_service_account_names      = ["vaulidate-env"]
  bound_service_account_namespaces = ["vaulidate-env"]
  token_ttl                        = 3600
  token_policies                   = ["default", "vaulidate-file"]
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "jenkins" {
  backend        = vault_auth_backend.approle.path
  role_name      = "jenkins"
  token_policies = ["default", "jenkins-vault-poc"]
}

resource "vault_approle_auth_backend_role" "gha" {
  backend        = vault_auth_backend.approle.path
  role_name      = "gha"
  token_policies = ["default", "gha-vault-poc"]
}

resource "vault_approle_auth_backend_role" "vaulidate" {
  backend        = vault_auth_backend.approle.path
  role_name      = "vaulidate"
  token_policies = ["default", "vaulidate-file"]
}

data "vault_approle_auth_backend_role_id" "jenkins" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.jenkins.role_name
}

resource "vault_approle_auth_backend_role_secret_id" "jenkins" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.jenkins.role_name
}

data "vault_approle_auth_backend_role_id" "gha" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.gha.role_name
}

resource "vault_approle_auth_backend_role_secret_id" "gha" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.gha.role_name
}

data "vault_approle_auth_backend_role_id" "vaulidate" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.vaulidate.role_name
}

resource "vault_approle_auth_backend_role_secret_id" "vaulidate" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.vaulidate.role_name
}

resource "vault_jwt_auth_backend" "aad" {
  description        = "Demonstration of the AAD auth backend"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = var.oidc_backend.discovery_url
  oidc_client_id     = var.oidc_backend.client_id
  oidc_client_secret = var.oidc_backend.client_secret
}

resource "vault_jwt_auth_backend_role" "aad-user" {
  backend   = vault_jwt_auth_backend.aad.path
  role_name = "test-role"
  role_type = "oidc"

  token_policies        = ["default", "gha-vault-poc"]
  user_claim            = "email"
  groups_claim          = "groups"
  allowed_redirect_uris = var.oidc_backend_role.redirect_uris
  oidc_scopes           = var.oidc_backend_role.oidc_scopes
  verbose_oidc_logging  = true
}

resource "vault_identity_group" "aad-group" {
  name     = "aad"
  type     = "external"
  policies = ["default"]

  metadata = {
    version = "1"
  }
}

resource "vault_identity_group_alias" "group-alias" {
  name           = var.aad_group_id
  mount_accessor = vault_jwt_auth_backend.aad.accessor
  canonical_id   = vault_identity_group.aad-group.id
}