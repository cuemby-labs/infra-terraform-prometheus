additionalPrometheusRulesMap:
  rule-name:
    groups:
    - name: rules-cuemby
      rules:
        #OpenEBS
        - alert: OpenebsUsedPoolCapacity
          expr: openebs_used_pool_capacity_percent > 90
          for: 2m
          labels:
            severity: warning
          annotations:
            summary: OpenEBS used pool capacity (instance {{ $$labels.instance }})
            description: "OpenEBS Pool use more than 90% of his capacity\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Host and hardware : node-exporter
        - alert: HostOutOfMemory
          expr: (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
          for: 2m
          labels:
            severity: warning
          annotations:
            summary: Host out of memory (instance {{ $$labels.instance }})
            description: "Node memory is filling up (< 10% left)\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Host memory under memory pressure
        - alert: HostMemoryUnderMemoryPressure
          expr: (rate(node_vmstat_pgmajfault[1m]) > 1000) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
          for: 2m
          labels:
            severity: warning
          annotations:
            summary: Host memory under memory pressure (instance {{ $$labels.instance }})
            description: "The node is under heavy memory pressure. High rate of major page faults\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Host unusual network throughput in
        - alert: HostUnusualNetworkThroughputIn
          expr: (sum by (instance) (rate(node_network_receive_bytes_total[2m])) / 1024 / 1024 > 100) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
          for: 5m
          labels:
            severity: warning
          annotations:
            summary: Host unusual network throughput in (instance {{ $$labels.instance }})
            description: "Host network interfaces are probably receiving too much data (> 100 MB/s)\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Host out of disk space
        - alert: HostOutOfDiskSpace
          expr: ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
          for: 2m
          labels:
            severity: warning
          annotations:
            summary: Host out of disk space (instance {{ $$labels.instance }})
            description: "Disk is almost full (< 10% left)\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Host disk will fill in 24 hours
        - alert: HostDiskWillFillIn24Hours
          expr: ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs"}[1h], 24 * 3600) < 0 and ON (instance, device, mountpoint) node_filesystem_readonly == 0) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
          for: 2m
          labels:
            severity: warning
          annotations:
            summary: Host disk will fill in 24 hours (instance {{ $$labels.instance }})
            description: "Filesystem is predicted to run out of space within the next 24 hours at current write rate\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Host high CPU load
        - alert: HostHighCpuLoad
          expr: (sum by (instance) (avg by (mode, instance) (rate(node_cpu_seconds_total{mode!="idle"}[2m]))) > 0.8) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
          for: 5m
          labels:
            severity: warning
          annotations:
            summary: Host high CPU load (instance {{ $$labels.instance }})
            description: "CPU load is > 90%\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Cloudflare http 4xx error rate
        - alert: CloudflareHttp4xxErrorRate
          expr: (sum by(zone) (rate(cloudflare_zone_requests_status{status=~"^4.."}[15m])) / on (zone) sum by (zone) (rate(cloudflare_zone_requests_status[15m]))) * 100 > 5
          for: 0m
          labels:
            severity: warning
          annotations:
            summary: Cloudflare http 4xx error rate (instance {{ $$labels.instance }})
            description: "Cloudflare high HTTP 4xx error rate (> 5% for domain {{ $$labels.zone }})\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Cloudflare http 5xx error rate
        - alert: CloudflareHttp5xxErrorRate
          expr: (sum by (zone) (rate(cloudflare_zone_requests_status{status=~"^5.."}[5m])) / on (zone) sum by (zone) (rate(cloudflare_zone_requests_status[5m]))) * 100 > 5
          for: 0m
          labels:
            severity: critical
          annotations:
            summary: Cloudflare http 5xx error rate (instance {{ $$labels.instance }})
            description: "Cloudflare high HTTP 5xx error rate (> 5% for domain {{ $$labels.zone }})\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        # Alerta si el certificado expira en 7 días
        - alert: SSLCertificateExpiringSoon
          expr: probe_ssl_earliest_cert_expiry - time() < 86400 * 7
          for: 5m
          labels:
            severity: critical
          annotations:
            summary: "SSL Certificate is expiring soon (instance {{ $$labels.instance }})"
            description: "SSL Certificate for {{ $$labels.instance }} expires in less than 7 days."
        #Blackbox SSL certificate will expire soon
        - alert: BlackboxSslCertificateWillExpireSoon
          expr: 0 <= round((last_over_time(probe_ssl_earliest_cert_expiry[10m]) - time()) / 86400, 0.1) < 3
          for: 0m
          labels:
            severity: critical
          annotations:
            summary: Blackbox SSL certificate will expire soon (instance {{ $$labels.instance }})
            description: "SSL certificate expires in less than 3 days\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Blackbox probe HTTP failure
        - alert: BlackboxProbeHttpFailure
          expr: probe_http_status_code <= 199 OR probe_http_status_code >= 400
          for: 0m
          labels:
            severity: critical
          annotations:
            summary: Blackbox probe HTTP failure (instance {{ $$labels.instance }})
            description: "HTTP status code is not 200-399\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
        #Vault sealed
        - alert: VaultSealed
          expr: vault_core_unsealed == 0
          for: 0m
          labels:
            severity: critical
          annotations:
            summary: Vault sealed (instance {{ $$labels.instance }})
            description: "Vault instance is sealed on {{ $$labels.instance }}\n  VALUE = {{ $$value }}\n  LABELS = {{ $$labels }}"
defaultRules:
  rules:
    kubeProxy: false
prometheus:
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
    static_configs:
    - targets: 
      - "http://localhost:9100/metrics"
    scheme: https
    tls_config:
      insecure_skip_verify: true
# Relabeling "instance" to remove the ":9100" part
  relabel_configs:
    - source_labels: prometheus-dev-prometheus-node-exporter
      target_label: instance
      regex: '([^:]+)(:[0-9]+)?'
      replacement: '${1}'
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