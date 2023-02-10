output "jenkins_role_id" {
  value = data.vault_approle_auth_backend_role_id.jenkins.role_id
}

output "jenkins_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.jenkins.secret_id
  sensitive = true
}

output "gha_role_id" {
  value = data.vault_approle_auth_backend_role_id.gha.role_id
}

output "gha_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.gha.secret_id
  sensitive = true
}

output "vaulidate_role_id" {
  value = data.vault_approle_auth_backend_role_id.vaulidate.role_id
}

output "vaulidate_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.vaulidate.secret_id
  sensitive = true
}