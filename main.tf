#
# Prometheus Resources
#

resource "kubernetes_namespace" "prometheus_alert" {
  metadata {
    name = var.namespace_name
  }
  
  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "helm_release" "kube_prometheus_alert" {
  name       = var.release_name
  namespace  = var.namespace_name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    yamlencode(var.values),
  ]
}

#
# Walrus information
#

locals {
  context = var.context
}