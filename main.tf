#
# Prometheus Resources
#

resource "kubernetes_namespace" "prometheus-alert" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "kube-prometheus-alert" {
  name       = var.release_name
  namespace  = var.namespace_name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values     = [file("${path.module}/values.yaml")]
}

#
# Walrus information
#

locals {
  context = var.context
}