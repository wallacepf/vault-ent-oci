resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.23.0"
  namespace  = kubernetes_namespace.vault.metadata[0].name

  reset_values = true

  values = [
    "${file("helm_values/vault_helm.yaml")}"
  ]
}

# resource "helm_release" "jenkins" {
#   name       = "jenkins"
#   repository = "https://charts.jenkins.io"
#   chart      = "jenkins"
#   namespace  = kubernetes_namespace.jenkins.metadata[0].name

#   reset_values = true

#   values = [
#     "${file("helm_values/jenkins.yaml")}"
#   ]
# }