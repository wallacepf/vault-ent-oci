variable "redirect_urls" {
  type = list(any)
}

variable "vault_user" {
  type = object({
    display_name        = string
    password            = string
    user_principal_name = string
  })
}