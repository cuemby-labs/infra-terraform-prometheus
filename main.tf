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

resource "kubernetes_secret" "secrets" {
  for_each = { for secret in var.secrets : secret.username => secret }

  metadata {
    name      = each.value.username
    namespace = var.namespace_name
  }

  data = {
    username = each.value.username
    password = each.value.password
  }

  type = "kubernetes.io/basic-auth"
}

resource "helm_release" "kube_prometheus_alert" {
  depends_on = [kubernetes_namespace.prometheus_system]

  name       = var.release_name
  namespace  = var.namespace_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = var.set_custom_values ? [yamlencode(var.values)] : []

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
# HPA
#

data "template_file" "hpa_manifest_template" {
  
  template = file("${path.module}/hpa.yaml.tpl")
  vars     = {
    namespace_name            = var.namespace_name,
    operator_name_metadata    = "${helm_release.kube_prometheus_alert.name}-kube-operator",
    operator_name_deployment  = "${helm_release.kube_prometheus_alert.name}-kube-prometheus-operator",
    metrics_name_metadata     = "${helm_release.kube_prometheus_alert.name}-kube-state-metrics",
    metrics_name_deployment   = "${helm_release.kube_prometheus_alert.name}-kube-state-metrics",
    min_replicas              = var.hpa_config.min_replicas,
    max_replicas              = var.hpa_config.max_replicas,
    target_cpu_utilization    = var.hpa_config.target_cpu_utilization,
    target_memory_utilization = var.hpa_config.target_memory_utilization
  }
}

data "kubectl_file_documents" "hpa_manifest_files" {

  content = data.template_file.hpa_manifest_template.rendered
}

resource "kubectl_manifest" "apply_hpa_manifests" {
  for_each  = data.kubectl_file_documents.hpa_manifest_files.manifests
  yaml_body = each.value
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