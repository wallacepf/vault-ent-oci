resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

# resource "kubernetes_namespace" "jenkins" {
#   metadata {
#     name = "jenkins"
#   }
# }