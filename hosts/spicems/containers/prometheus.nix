{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
  dockerDir = vars.system.dockerDir;
in {
  virtualisation.oci-containers.containers = {
    prometheus = {
      image = "prom/prometheus:latest";
      autoStart = true;

      ports = [
        "9200:9090"
      ];

      networks = [
        "t2_proxy"
      ];

      volumes = [
        "${dockerDir}/prometheus:/etc/prometheus"
      ];

      command = [
        "--config.file=/etc/prometheus/prometheus.yml"
      ];
    };

    node-exporter = {
      image = "quay.io/prometheus/node-exporter:latest";
      autoStart = true;

      cmd = [
        "--path.rootfs=/host"
        # Optional but recommended additions in many setups:
        # "--path.procfs=/host/proc"
        # "--path.sysfs=/host/sys"
      ];
      #      pid = host
      ports = [
        "9100:9100"
      ];
      extraOptions = [
        "--pid=host"
        "--network=host"
        # Alternative (if you really need the t2_proxy bridge network):
        # "--network=t2_proxy"
        # "--pid=host"
      ];
      volumes = [
        "/:/host:ro"
      ];

      #      networks = [
      #        "t2_proxy"
      #      ];
    };
  };
}
