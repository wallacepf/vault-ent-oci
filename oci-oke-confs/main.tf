provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  access_key = var.aws_creds.access_key
  secret_key = var.aws_creds.secret_key
  region     = var.aws_region
}

