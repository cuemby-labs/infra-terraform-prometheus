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
# Harbor manifest variables
#

variable "channel-teams" {
  type        = string
  description = "Channel Microsoft Teams"
  default     = "alerts_dev-stg"
}

variable "domain_name" {
  type        = string
  description = "Domain name for Harbor, e.g. 'dev.domainname.com'"
  default     = "dev.domainname.com"
}

variable "dash_domain_name" {
  type        = string
  description = "Domain name with dash, e.g. 'dev-domainname-com'"
  default     = "dev-domainname-com"
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

variable "additional_prometheus_rules_map" {
  type        = map(any)
  description = "additionalPrometheusRulesMap"
  default     = {
    "rule-name" = {
      groups = [
        {
          name  = "rules-cuemby"
          rules = [
            {
              alert       = "OpenebsUsedPoolCapacity"
              expr        = "openebs_used_pool_capacity_percent > 90"
              for         = "2m"
              labels      = { severity = "warning" }
              annotations = {
                summary     = "OpenEBS used pool capacity (instance {{ $labels.instance }})"
                description = "OpenEBS Pool use more than 90% of his capacity\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
              }
            },
            {
              alert       = "HostOutOfMemory"
              expr        = "(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10) * on(instance) group_left (nodename) node_uname_info{nodename=~\".+\"}"
              for         = "2m"
              labels      = { severity = "warning" }
              annotations = {
                summary     = "Host out of memory (instance {{ $labels.instance }})"
                description = "Node memory is filling up (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
              }
            },
            {
              alert       = "HostMemoryUnderMemoryPressure"
              expr        = "(rate(node_vmstat_pgmajfault[1m]) > 1000) * on(instance) group_left (nodename) node_uname_info{nodename=~\".+\"}"
              for         = "2m"
              labels      = { severity = "warning" }
              annotations = {
                summary     = "Host memory under memory pressure (instance {{ $labels.instance }})"
                description = "The node is under heavy memory pressure. High rate of major page faults\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
              }
            }
          ]
        }
      ]
    }
  }
}

variable "prometheus_alert_rules_map2" {
  description = "Map of Prometheus alert rules"
  type = map(object({
    expr        = string
    for         = string
    severity    = string
    summary     = string
    description = string
  }))
  default = {
    "HostUnusualNetworkThroughputIn" = {
      expr        = "(sum by (instance) (rate(node_network_receive_bytes_total[2m])) / 1024 / 1024 > 100) * on(instance) group_left (nodename) node_uname_info{nodename=~\".+\"}"
      for         = "5m"
      severity    = "warning"
      summary     = "Host unusual network throughput in (instance {{ $labels.instance }})"
      description = "Host network interfaces are probably receiving too much data (> 100 MB/s)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
    },
    "HostHighCpuLoad" = {
      expr        = "(sum by (instance) (avg by (mode, instance) (rate(node_cpu_seconds_total{mode!=\"idle\"}[2m]))) > 0.8) * on(instance) group_left (nodename) node_uname_info{nodename=~\".+\"}"
      for         = "5m"
      severity    = "warning"
      summary     = "Host high CPU load (instance {{ $labels.instance }})"
      description = "CPU load is > 90%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
    }
  }
}

variable "additional_scrape_configs" {
  type        = map(string)
  description = "additionalScrapeConfigs"
  default     = "{}"
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