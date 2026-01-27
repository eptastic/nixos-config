{
  config,
  pkgs,
  ...
}: {
  services.prometheus = {
    enable = true;

    # Listen on port 9090 (default)
    # → you can access http://localhost:9090
    port = 9090;

    # Global settings (exactly matching your request)
    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
      # scrape_timeout defaults to 10s
    };

    # Alertmanager (commented out for now – uncomment when you add Alertmanager)
    alertmanagers = [
      # {
      #   static_configs = [{
      #     targets = [ "localhost:9093" ];  # or your alertmanager container/IP
      #   }];
      # }
    ];

    # Rule files (empty for basic setup – add later when you have alerting/recording rules)
    ruleFiles = [
      # ./first_rules.yml
      # ./second_rules.yml
    ];

    # Scrape jobs – your basic self-monitoring
    scrapeConfigs = [
      {
        job_name = "prometheus";

        # metrics_path defaults to /metrics
        # scheme defaults to http

        static_configs = [
          {
            targets = ["localhost:9090"];
            labels = {
              app = "prometheus";
            };
          }
        ];
      }

      # ← Add more jobs later, e.g. node-exporter:
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };

  # Optional but very useful: open the port in firewall
  # networking.firewall.allowedTCPPorts = [config.services.prometheus.port];

  # Optional: enable the built-in node exporter (highly recommended for basic host metrics)
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100; # default
  };

  # If you enabled node exporter above, add this scrape job automatically:
  # (you can do it manually as shown in comment above)
}
