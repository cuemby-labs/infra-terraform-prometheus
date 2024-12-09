#
# Prometheus Resources
#

data "kubernetes_namespace" "prometheus_system" {
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_namespace" "prometheus_system" {
  metadata {
    name = var.namespace_name
  }
  count = length(data.kubernetes_namespace.prometheus_system.id) == 0 ? 1 : 0
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
  depends_on = [kubernetes_namespace.prometheus_system]

  name       = var.release_name
  namespace  = var.namespace_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    yamlencode(var.values),
  ]

  set {
    name  = "alertmanager.alertmanagerSpec.resources.requests.cpu"
    value = var.resources["alertmanager"]["requests"]["cpu"]
  }
  set {
    name  = "alertmanager.alertmanagerSpec.resources.requests.memory"
    value = var.resources["alertmanager"]["requests"]["memory"]
  }
  set {
    name  = "alertmanager.alertmanagerSpec.resources.limits.cpu"
    value = var.resources["alertmanager"]["limits"]["cpu"]
  }
  set {
    name  = "alertmanager.alertmanagerSpec.resources.limits.memory"
    value = var.resources["alertmanager"]["limits"]["memory"]
  }
  set {
    name  = "prometheusOperator.resources.requests.cpu"
    value = var.resources["operator"]["requests"]["cpu"]
  }
  set {
    name  = "prometheusOperator.resources.requests.memory"
    value = var.resources["operator"]["requests"]["memory"]
  }
  set {
    name  = "prometheusOperator.resources.limits.cpu"
    value = var.resources["operator"]["limits"]["cpu"]
  }
  set {
    name  = "prometheusOperator.resources.limits.memory"
    value = var.resources["operator"]["limits"]["memory"]
  }
  set {
    name  = "prometheus.prometheusSpec.resources.requests.cpu"
    value = var.resources["prometheus"]["requests"]["cpu"]
  }
  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = var.resources["prometheus"]["requests"]["memory"]
  }
  set {
    name  = "prometheus.prometheusSpec.resources.limits.cpu"
    value = var.resources["prometheus"]["limits"]["cpu"]
  }
  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = var.resources["prometheus"]["limits"]["memory"]
  }
}

#
# Walrus information
#

locals {
  context = var.context
}

module "submodule" {
  source = "./modules/submodule"

  message = "Hello, submodule"
}