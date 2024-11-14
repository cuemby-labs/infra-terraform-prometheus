additionalPrometheusRulesMap:
  rule-name:
    groups:
    - name: prometheus-rules
      rules:
%{ for rule in rules ~}
        - alert: ${rule.alert}
          expr: ${rule.expr}
          for: ${rule.for}
          labels:
            severity: ${rule.severity}
          annotations:
            summary: ${rule.summary}
            description: ${rule.description}
%{ endfor ~}
defaultRules:
  rules:
    kubeProxy: false
prometheus:
  prometheusSpec:
    additionalScrapeConfigs:
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
        kubernetes_sd_configs:
          - role: endpoints
        relabel_configs:
        - source_labels: [__meta_kubernetes_endpoints_name]
          regex: 'node-exporter'
          action: keep
  service:
    type: ClusterIP
  ingress:
    hosts:
        - prometheus.${domain_name}
    annotations:
      cert-manager.io/issuer: ${issuer_name}
      cert-manager.io/issuer-kind: ${issuer_kind}
      cert-manager.io/issuer-group: cert-manager.k8s.cloudflare.com
      external-dns.alpha.kubernetes.io/cloudflare-proxied: 'true'
      external-dns.alpha.kubernetes.io/hostname: prometheus.${domain_name}
      nginx.ingress.kubernetes.io/whitelist-source-range: '${whitelist_ips_string}'
    enabled: true
    ingressClassName: nginx
    tls:
      - hosts:
          - prometheus.${domain_name}
        secretName: prometheus-${dash_domain_name}
alertmanager:
  enabled: true
  config:
    global:
      resolve_timeout: 10m
    route:
      group_by: ['job']
      group_wait: 5m
      group_interval: 15m
      repeat_interval: 1h
      receiver: 'webhook'
    receivers:
    - name: 'webhook'
      webhook_configs:
      - url: 'http://prometheus-msteams:2000/${channel_teams}'
        send_resolved: true
  alertmanagerSpec:
    configSecret: ${config_secret}
kubeControllerManager:
  enabled: falspush
kubeScheduler:
  enabled: false
kubeEtcd:
  enabled: false
grafana:
  enabled: ${grafana_enabled}
  ingress:
    enabled: ${grafana_ingress_enabled}
    hosts:
      - grafana.${domain_name}
    annotations:
      cert-manager.io/issuer: ${issuer_name}
      cert-manager.io/issuer-kind: ${issuer_kind}
      cert-manager.io/issuer-group: cert-manager.k8s.cloudflare.com
      external-dns.alpha.kubernetes.io/cloudflare-proxied: 'true'
      external-dns.alpha.kubernetes.io/hostname: grafana.${domain_name}
    ingressClassName: nginx
    tls:
      - hosts:
          - grafana.${domain_name}
        secretName: grafana-${dash_domain_name}