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

variable "channel_teams" {
  type        = string
  description = "Channel Microsoft Teams"
  default     = "alerts_dev-stg"
}

variable "domain_name" {
  type        = string
  description = "Domain name for Harbor, e.g. 'dev.domainname.com'"
  default     = "dev.domainname.com"
}

variable "issuer_name" {
  type        = string
  description = "Origin issuer name"
  default     = "origin-ca-issuer"
}

variable "issuer_kind" {
  type        = string
  description = "Origin issuer kind"
  default     = "ClusterOriginIssuer"
}

variable "grafana_enabled" {
  type        = bool
  description = "Grafana Enabled"
  default     = "false"
}

variable "grafana_ingress_enabled" {
  type        = bool
  description = "Grafana Ingress Enabled"
  default     = "false"
}

variable "whitelist_ips" {
  type        = list(string)
  description = "List of IP addresses to be whitelisted"
  default     = ["192.168.1.1", "192.168.1.2", "192.168.1.3"]
}

variable "config_secret" {
  type        = string
  description = "SecretConfig for MSTeams"
  default     = "alertmanager-prometheus-kube-prometheus-alertmanager"
}

variable "rules" {
  description = "Adding rules for AlertManager"
  type = list(object({
    alert       = string
    expr        = string
    for         = string
    severity    = string
    summary     = string
    description = string
  }))

  default = [
    {
      alert       = "HostOutOfMemory"
      expr        = "(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10) * on(instance) group_left (nodename) node_uname_info{nodename=~'.+'}"
      for         = "2m"
      severity    = "warning"
      summary     = "Host out of memory (instance  \\{\\{ $$labels.instance \\}\\})"
      description = "Node memory is filling up (< 10% left)\n  VALUE =  \\{\\{ $$value \\}\\}\n  LABELS =  \\{\\{ $$labels \\}\\}"
    }
  ]
}

variable "additional_scrape_configs" {
  description = "YAML configuration for additional scrape configs in Prometheus"
  type        = string
  default     = <<-EOT
- job_name: 'vault'
  kubernetes_sd_configs:
    - role: endpoints
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name]
      action: keep
      regex: ccp-dev;vault
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
      action: replace
      target_label: __metrics_path__
      regex: (.*)
    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_port]
      action: replace
      target_label: __address__
      regex: (.*)
      replacement: $1
- job_name: 'node-exporter'
  static_configs:
  - targets:
    - "http://prometheus-prometheus-node-exporter:9100/metrics"
  scheme: https
  tls_config:
    insecure_skip_verify: true
EOT
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