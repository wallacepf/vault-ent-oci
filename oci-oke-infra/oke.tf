module "oke" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "~> 4.4.2"

  home_region = var.region
  region      = var.region

  tenancy_id = var.oci_tenancy_id

  # general oci parameters
  compartment_id = oci_identity_compartment.vault_poc.id
  label_prefix   = "vault-poc"

  vcn_cidrs     = [var.vcn_cidr]
  vcn_dns_label = "vaultpoc"
  vcn_name      = "vcn"

  # bastion host
  create_bastion_host = false
  upgrade_bastion     = false

  # operator host
  create_operator                    = false
  enable_operator_instance_principal = false
  upgrade_operator                   = false

  # oke cluster options
  cluster_name                = "k8s1"
  control_plane_type          = "public"
  control_plane_allowed_cidrs = ["0.0.0.0/0"]
  kubernetes_version          = "v1.25.4"
  pods_cidr                   = var.oke_subnets.oke_pods
  services_cidr               = var.oke_subnets.services

  # node pools
  node_pools = {
    np1 = { shape = "VM.Standard.E2.2", ocpus = 2, memory = 16, node_pool_size = 3, boot_volume_size = 150, label = { app = "frontend", pool = "np1" } }
  }
  node_pool_name_prefix = "vault-poc"

  # oke load balancers
  load_balancers          = "both"
  preferred_load_balancer = "public"
  public_lb_allowed_cidrs = ["0.0.0.0/0"]
  public_lb_allowed_ports = [80, 443]

  providers = {
    oci.home = oci.home
  }
}