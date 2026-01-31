{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
in {
  virtualisation.oci-containers.containers = {
    radarr = {
      image = "linuxserver/radarr:latest";
      autoStart = true;

      environment = {
        PUID = vars.user.uid;
        PGID = vars.user.pid;
        TZ = vars.user.tz;
      };

      volumes = [
        "${vars.system.dockerDir}/radarr:/config"
        "${vars.system.sabDir}/complete:/downloads"
        "${vars.system.mediaDir}/movies:/movies"
        "${vars.system.dockerDir}/shared:/shared"
        "${vars.system.arrayDir}/recycling_bin:/recycling_bin"
        "/etc/localtime:/etc/localtime:ro"
      ];

      ports = [
        "7878:7878"
      ];

      log-driver = vars.common.logDriver;

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.radarr-rtr.entrypoints" = "https";
        "traefik.http.routers.radarr-rtr.rule" = "Host(`radarr.${domainName}`)";
        "traefik.http.routers.radarr-rtr.tls" = "true";
        "traefik.http.routers.radarr-rtr.service" = "radarr-svc";
        "traefik.http.services.radarr-svc.loadbalancer.server.port" = "7878";
        "traefik.http.routers.radarr-rtr.middlewares" = "chain-authelia@file";
      };
    };

    radarr4k = {
      image = "linuxserver/radarr";
      autoStart = true;

      environment = {
        PUID = vars.user.uid;
        PGID = vars.user.pid;
        TZ = vars.user.tz;
      };

      volumes = [
        "${vars.system.dockerDir}/radarr_4k:/config"
        "${vars.system.sabDir}/complete:/downloads"
        "${vars.system.mediaDir}/4k:/4k"
        "${vars.system.dockerDir}/shared:/shared"
        "${vars.system.arrayDir}/recycling_bin:/recycling_bin"
        "/etc/localtime:/etc/localtime:ro"
      ];

      ports = [
        "7979:7878"
      ];

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.radarr4k-rtr.entrypoints" = "https";
        "traefik.http.routers.radarr4k-rtr.rule" = "Host(`radarr4k.${domainName}`)";
        "traefik.http.routers.radarr4k-rtr.tls" = "true";
        "traefik.http.routers.radarr4k-rtr.service" = "radarr4k-svc";
        "traefik.http.services.radarr4k-svc.loadbalancer.server.port" = "7878";
        "traefik.http.routers.radarr4k-rtr.middlewares" = "chain-authelia@file";
      };

      log-driver = vars.common.logDriver;
    };
  };

  systemd.services."podman-radarr" = {
    after = ["zfs-import-thufir2.service" "zfs-mount.service"];
    requires = ["zfs-import-thufir2.service"];
  };

  systemd.services."podman-radarr4k" = {
    after = ["zfs-import-thufir2.service" "zfs-mount.service"];
    requires = ["zfs-import-thufir2.service"];
  };
}
