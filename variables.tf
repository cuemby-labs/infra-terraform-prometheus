#
# Prometheus variables
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
  description = "The version of the ingress-nginx Helm chart."
  type        = string
  default     = "64.0.0"
}

#
# Prometheus manifest variables
#

variable "domain_name" {
  type        = string
  description = "domain name for Prometheus, e.g. 'dev.domainname.com'"
  default     = "dev.domainname.com"
}

variable "dash_domain_name" {
  type        = string
  description = "domain name with dash, e.g. 'dev-domainname-com'"
  default     = "dev-domainname-com"
}

variable "issuer_name" {
  type        = string
  description = "origin issuer name"
  default     = "origin-ca-issuer"
}

variable "issuer_kind" {
  type        = string
  description = "origin issuer kind"
  default     = "ClusterOriginIssuer"
}

#View Documentation to Ms Teams.
variable "channel" {
  type        = string
  description = "Channel config to Microsoft Teams"
  default     = "alerts"
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