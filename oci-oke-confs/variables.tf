variable "oci_creds" {
  type = object({
    user        = string
    fingerprint = string
    tenancy     = string
    region      = string
    cli_auth    = string
  })
  default = {
    cli_auth    = "api_key"
    fingerprint = ""
    region      = ""
    tenancy     = ""
    user        = ""
  }
}

variable "vault_license" {
  type = string
}

variable "aws_creds" {
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "aws_region" {
  type = string
}

variable "docker_creds" {
  type = object({
    docker_user     = string
    docker_password = string
    docker_server   = string
    docker_email    = string
  })
}