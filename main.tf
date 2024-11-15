#
# Prometheus Resources
#

resource "kubernetes_namespace" "prometheus_alert" {
  metadata {
    name = var.namespace_name
  }
}

data "http" "remote_values_file" {
  url = var.values
}

resource "helm_release" "kube_prometheus_alert" {
  name       = var.release_name
  namespace  = var.namespace_name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    yamldecode(local.values_with_vars)
  ]
}

#
# Walrus information
#

locals {
  context = var.context

  replacements = {
    "var_channel_teams"           = var.channel_teams
    "var_domain_name"             = var.domain_name
    "var_dash_domain_name"        = local.dash_domain_name
    "var_issuer_name"             = var.issuer_name
    "var_issuer_kind"             = var.issuer_kind
    "var_grafana_enabled"         = tostring(var.grafana_enabled)
    "var_grafana_ingress_enabled" = tostring(var.grafana_ingress_enabled)
    "var_whitelist_ips_string"    = local.whitelist_ips_string
    "var_config_secret"           = var.config_secret
  }

  whitelist_ips_string = join(",", var.whitelist_ips)
  dash_domain_name     = replace(var.domain_name, ".", "-")

  # Aplicar todos los reemplazos en una sola operación
  values_with_vars = reduce(local.replacements, data.http.remote_values_file.response_body, 
    (val, pair) => replace(val, pair.key, pair.value)
  )
}