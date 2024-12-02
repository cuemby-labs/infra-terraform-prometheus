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

variable "username" {
  description = "The username for the secret."
  type        = string
  default     = ""
}

variable "password" {
  description = "The password for the secret."
  type        = string
  sensitive   = true
  default     = ""
}

variable "set_custom_values" {
  type = bool
  description = "Set custom values"
  default = false
}

variable "values" {
  type = any
  description = "Chart values for Prometheus HelmChart, more info https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack?modal=values"
  default = {}
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