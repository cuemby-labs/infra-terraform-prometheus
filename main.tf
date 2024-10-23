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

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      channel-teams                   = var.channel-teams,
      domain_name                     = var.domain_name,
      dash_domain_name                = var.dash_domain_name
      issuer_name                     = var.issuer_name
      issuer_kind                     = var.issuer_kind
      grafana_enabled                 = var.grafana_enabled
      grafana_ingress_enabled         = var.grafana_ingress_enabled
    })
  ]
}

#
# Walrus information
#

locals {
  context = var.context
}