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

variable "secrets" {
  description = "List of secrets with username and password"

  type = list(object({
    username = string
    password = string
  }))

  default = [
    {
      username = "user1"
      password = "password1"
    },
    {
      username = "user2"
      password = "password2"
    }
  ]
}


variable "set_custom_values" {
  type = bool
  description = "Set custom values"
  default = false
}

variable "resources" {
  description = "Resource limits and requests for Prometheus Helm release."
  type        = map(object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  }))

  default = {
    alertmanager = {
      limits = {
        cpu    = "200m"
        memory = "800Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "400Mi"
      }
    }
    operator = {
      limits = {
        cpu    = "200m"
        memory = "200Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "100Mi"
      }
    }
    prometheus = {
      limits = {
        cpu    = "200m"
        memory = "800Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "400Mi"
      }
    }
  }
}

variable "values" {
  type = any
  description = "Chart values for Prometheus HelmChart, more info https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack?modal=values"
  default = {}
}

variable "hpa_config" {
  description = "Configuration for the HPA targeting Prometheus Deployment"
  type        = object({
    min_replicas              = number
    max_replicas              = number
    target_cpu_utilization    = number
    target_memory_utilization = number
  })

  default = {
    min_replicas              = 1
    max_replicas              = 3
    target_cpu_utilization    = 80
    target_memory_utilization = 80
  }
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