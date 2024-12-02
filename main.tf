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

resource "kubernetes_secret" "secret" {
  metadata {
    name      = var.username
    namespace = var.namespace_name
  }

  data = {
    username = base64encode(var.username)  # Encode username in base64
    password = base64encode(var.password)  # Encode password in base64
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