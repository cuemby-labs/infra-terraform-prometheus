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
  context              = var.context
  values_with_vars = replace(
    replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                replace(
                  replace(
                    replace(
                      data.http.remote_values_file.response_body,
                      "${channel_teams}", var.channel_teams
                    ),
                    "${domain_name}", var.domain_name
                  ),
                  "${dash_domain_name}", local.dash_domain_name
                ),
                "${issuer_name}", var.issuer_name
              ),
              "${issuer_kind}", var.issuer_kind
            ),
            "${grafana_enabled}", tostring(var.grafana_enabled)
          ),
          "${grafana_ingress_enabled}", tostring(var.grafana_ingress_enabled)
        ),
        "${whitelist_ips_string}", local.whitelist_ips_string
      ),
      "${config_secret}", var.config_secret
    )
  )
  whitelist_ips_string = join(",", var.whitelist_ips)
  dash_domain_name     = replace(var.domain_name, ".", "-")
}