additionalPrometheusRulesMap:
  ${additionalPrometheusRulesMap}
defaultRules:
  rules:
    kubeProxy: false
prometheus:
  prometheusSpec:
    additionalScrapeConfigs:
      ${additionalScrapeConfigs}
#Fin
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
      nginx.ingress.kubernetes.io/whitelist-source-range: ${whitelist_ips_string}
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
    configSecret: myalertmanager
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
prometheusOperator:
  admissionsWebhooks:
    certManager:
      enabled: true