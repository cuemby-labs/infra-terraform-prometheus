# Prometheus Template

Terraform module which deploys Prometheus on any kubernetes cluster.

## Usage

```hcl
module "prometheus" {
  source          = "./modules/origin-ca"                   # Path to the External-DNS module

  namespace_name  = "origin-ca"                             # The namespace where Origin-CA will be created
  image_version   = "cloudflare/origin-ca-issuer:v0.9.0"    # origin-ca-issuer version.
  key             = "secret key for cloudflare"             # secret key for cloudflare
  manifests_urls  = [url1, url2]                            # List of HTTP RAW URLs for kubernetes manifest
}
```

## Examples

- ...
- ...

## Contributing

Please read our [contributing guide](./docs/CONTRIBUTING.md) if you're interested in contributing to Walrus template.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | >= 1.5.7 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [helm_release.example](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace_name"></a> [namespace_name](#input_namespace_name) | Namespace where Prometheus will be installed. | string | "prometheus-system" | no |
| <a name="input_release_name"></a> [release_name](#input_release_name) | The name of the Helm release. | string | "prometheus" | no |
| <a name="input_chart_version"></a> [chart_version](#input_chart_version) | The version of the Prometheus Helm chart. | string | "64.0.0" | yes |
| <a name="input_channel-teams"></a> [channel-teams](#input_channel-teams) | Channel Microsoft Teams. | string | "" | yes |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name) | Domain name for Harbor, e.g. 'dev.domainname.com'. | string | "dev.domainname.com" | no |
| <a name="input_dash_domain_name"></a> [dash_domain_name](#input_dash_domain_name) | Domain name with dash, e.g. 'dev-domainname-com'. | string | "dev-domainname-com" | no |
| <a name="input_issuer_name"></a> [issuer_name](#input_issuer_name) | Origin issuer name. | string | "origin-ca-issuer" | yes |
| <a name="input_issuer_kind"></a> [issuer_kind](#input_issuer_kind) | Origin issuer kind. | string | "ClusterOriginIssuer" | no |
| <a name="input_grafana_enabled"></a> [grafana_enabled](#input_grafana_enabled) | Grafana Enabled. | bool | "false" | no |
| <a name="input_grafana_ingress_enabled"></a> [grafana_ingress_enabled](#input_grafana_ingress_enabled) | Grafana Ingress Enabled. | bool | "false" | no |
| <a name="input_additional_prometheus_rules_map"></a> [additional_prometheus_rules_map](#input_additional_prometheus_rules_map) | additionalPrometheusRulesMap. | map(any) | "{}" | yes |
| <a name="input_additional_scrape_configs"></a> [additional_scrape_configs](#input_additional_scrape_configs) | additionalScrapeConfigs. | map(string) | "{}" | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_submodule"></a> [submodule](#output\_submodule) | The message from submodule. |
| <a name="output_walrus_environment_id"></a> [walrus\_environment\_id](#output\_walrus\_environment\_id) | The id of environment where deployed in Walrus. |
| <a name="output_walrus_environment_name"></a> [walrus\_environment\_name](#output\_walrus\_environment\_name) | The name of environment where deployed in Walrus. |
| <a name="output_walrus_project_id"></a> [walrus\_project\_id](#output\_walrus\_project\_id) | The id of project where deployed in Walrus. |
| <a name="output_walrus_project_name"></a> [walrus\_project\_name](#output\_walrus\_project\_name) | The name of project where deployed in Walrus. |
| <a name="output_walrus_resource_id"></a> [walrus\_resource\_id](#output\_walrus\_resource\_id) | The id of resource where deployed in Walrus. |
| <a name="output_walrus_resource_name"></a> [walrus\_resource\_name](#output\_walrus\_resource\_name) | The name of resource where deployed in Walrus. |
<!-- END_TF_DOCS -->

## License

Copyright (c) 2023 [Seal, Inc.](https://seal.io)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [LICENSE](./LICENSE) file for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
