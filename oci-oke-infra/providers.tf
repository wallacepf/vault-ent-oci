terraform {
  required_providers {
    oci = {
      source                = "oracle/oci"
      configuration_aliases = [oci.home]
      version               = "~> 4.105"
    }
  }
  required_version = ">= 1.0.0"
}

locals {
  tags = { "Terraform" = "True", "POC" = "True", "Solution" = "Vault" }
}

provider "oci" {
  tenancy_ocid     = var.oci_tenancy_id
  user_ocid        = var.oci_user_id
  private_key_path = var.private_key_path
  fingerprint      = var.oci_auth_fingerprint
  region           = var.region
}

provider "oci" {
  tenancy_ocid     = var.oci_tenancy_id
  user_ocid        = var.oci_user_id
  private_key_path = var.private_key_path
  fingerprint      = var.oci_auth_fingerprint
  region           = var.region
  alias            = "home"
}

resource "oci_identity_compartment" "vault_poc" {
  compartment_id = var.oci_tenancy_id
  description    = "Vault POC"
  name           = "vault_poc"
  enable_delete  = true

  freeform_tags = local.tags
}