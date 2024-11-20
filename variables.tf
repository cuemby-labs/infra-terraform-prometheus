#
# Harbor variables
#

variable "release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "prometheus"
}

variable "namespace_name" {
  description = "The namespace where the Helm release will be installed."
  type        = string
  default     = "prometheus-system"
}

variable "chart_version" {
  description = "The version of the Prometheus Helm chart."
  type        = string
  default     = "64.0.0"
}

#
# Prometheus manifest variables
#

# variable "channel_teams" {
#   type        = string
#   description = "Channel Microsoft Teams"
#   default     = "alerts_dev-stg"
# }

# variable "domain_name" {
#   type        = string
#   description = "Domain name for Harbor, e.g. 'dev.domainname.com'"
#   default     = "dev.domainname.com"
# }

# variable "issuer_name" {
#   type        = string
#   description = "Origin issuer name"
#   default     = "origin-ca-issuer"
# }

# variable "issuer_kind" {
#   type        = string
#   description = "Origin issuer kind"
#   default     = "ClusterOriginIssuer"
# }

# variable "grafana_enabled" {
#   type        = bool
#   description = "Grafana Enabled"
#   default     = "false"
# }

# variable "grafana_ingress_enabled" {
#   type        = bool
#   description = "Grafana Ingress Enabled"
#   default     = "false"
# }

# variable "whitelist_ips" {
#   type        = list(string)
#   description = "List of IP addresses to be whitelisted"
#   default     = ["192.168.1.1", "192.168.1.2", "192.168.1.3"]
# }

# variable "config_secret" {
#   type        = string
#   description = "SecretConfig for MSTeams"
#   default     = "alertmanager-prometheus-kube-prometheus-alertmanager"
# }

variable "prometheus_values" {
  type        = string
  description = "Raw URL with the values file for Prometheus HelmChart, more info https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack?modal=values"
  default     = "https://raw.githubusercontent.com/cuemby-labs/infra-terraform-prometheus/refs/tags/v1.0.7/values.yaml"
}

#
# Walrus Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}