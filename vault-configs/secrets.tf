resource "vault_mount" "kvv2" {
  path        = "secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

######### JENKINS TEST

resource "vault_kv_secret_v2" "vault-poc" {
  mount = vault_mount.kvv2.path
  name  = "vault-poc"

  data_json = jsonencode(
    {
      username = "wallacepf",
      password = "P@ssw0rd_Fr0m_J3nk1ns"
    }
  )
}

############# GHA TEST

resource "vault_kv_secret_v2" "dh-creds" {
  mount = vault_mount.kvv2.path
  name  = "gha/dh_creds"

  data_json = jsonencode(
    {
      dh_username = "${var.docker_creds.docker_user}",
      dh_password = "${var.docker_creds.docker_password}"
    }
  )
}

resource "vault_kv_secret_v2" "vaulidate" {
  mount = vault_mount.kvv2.path
  name  = "gha/vaulidate"

  data_json = jsonencode(
    {
      username = "wallacepf",
      password = "P@ssw0rd_From_Gh4"
    }
  )
}

resource "vault_kv_secret_v2" "vaulidate-mysecret" {
  mount = vault_mount.kvv2.path
  name  = "vaulidate/mysecret"

  data_json = jsonencode(
    {
      username = "wallacepf",
      password = "vaulidatemodestest_native_second_version"
    }
  )
}

########## DYN SECRETS TEST

resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = "postgres"
  allowed_roles = ["readonly"]

  postgresql {
    connection_url = var.postgres_conn_url
  }
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_mount.db.path
  name                = "readonly"
  default_ttl         = 43200
  max_ttl             = 86400
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
}