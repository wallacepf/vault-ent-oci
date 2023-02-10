output "aad_appid" {
  value = azuread_application.vault.application_id
}

output "azuread_group_object_id" {
  value = azuread_group.vault-poc.object_id
}