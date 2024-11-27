#
# install values
#

data "http" "prometheus_values" {
  url = var.prometheus_values
}

#
# Prometheus Resources
#

resource "kubernetes_namespace" "prometheus_alert" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "kube_prometheus_alert" {
  name       = var.release_name
  namespace  = var.namespace_name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    local.prometheus_values_encoded
  ]
}

#
# Walrus information
#

locals {
  context                   = var.context
  prometheus_values_decoded = yamldecode(data.http.prometheus_values.body)
  prometheus_values_encoded = jsonencode(local.prometheus_values_decoded)
}