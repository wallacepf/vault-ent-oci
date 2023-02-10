# variable "root_compartment_id" {
#   type = string
# }

variable "oci_tenancy_id" {
  type = string
}

variable "region" {
  type = string
}

variable "region_oke" {
  type    = string
  default = "sa-saopaulo-1"
}

variable "oci_auth_fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "oci_user_id" {
  type = string

}

variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "oke_subnets" {
  type = object({
    oke_api_endpoint = string
    oke_worker_nodes = string
    oke_pods         = string
    public_lb        = string
    bastion          = string
    services         = string
  })
  default = {
    bastion          = "10.0.3.0/24"
    oke_api_endpoint = "10.0.0.0/30"
    oke_pods         = "10.244.0.0/16"
    oke_worker_nodes = "10.0.1.0/24"
    public_lb        = "10.0.2.0/24"
    services         = "10.96.0.0/16"
  }
}