variable "kubernetes_ca_cert" {
  type = string
}

variable "token_reviewer_jwt" {
  type = string
}

variable "docker_creds" {
  type = object({
    docker_user     = string
    docker_password = string
  })
}

variable "oidc_backend" {
  type = object({
    discovery_url = string
    client_id = string
    client_secret = string
  })
}

variable "oidc_backend_role" {
  type = object({
    redirect_uris = list
    oidc_scopes = list
  })
}

variable "postgres_conn_url" {
  type = string
}

variable "aad_group_id" {
  type = string
}