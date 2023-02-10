provider "azuread" {}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

resource "azuread_application" "vault" {
  display_name            = "vault"
  group_membership_claims = ["SecurityGroup"]
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["GroupMember.Read.All"]
      type = "Scope"
    }
  }

  optional_claims {
    id_token {
      name                  = "groups"
      additional_properties = []
    }
    id_token {
      name                  = "email"
      additional_properties = []
    }
  }

  web {
    redirect_uris = var.redirect_urls
  }
}

data "azuread_client_config" "current" {}

resource "azuread_user" "vault-user" {
  display_name        = var.vault_user.display_name
  password            = var.vault_user.password
  user_principal_name = var.vault_user.user_principal_name
}

resource "azuread_group" "vault-poc" {
  display_name     = "Vault_POC"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    azuread_user.vault-user.object_id,
  ]
}