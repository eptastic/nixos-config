{config, ...}: let
  vars = import ./variables.nix;
  dockerDir = vars.system.dockerDir;
  arrayDir = vars.system.arrayDir;
in {
  virtualisation.oci-containers.containers = {
    copyparty = {
      image = "copyparty/ac:latest";
      autoStart = true;

      user = "1000:1000";

      ports = ["3923:3923"];

      volumes = [
        "${dockerDir}/copyparty:/cfg:z"
        "${arrayDir}:/w:z"
      ];

      environment = {
        LD_PRELOAD = "/usr/lib/libmimalloc-secure.so.2"; # ← enabled version
        PYTHONUNBUFFERED = "1";
      };

      extraOptions = ["--stop-timeout=15"];

      networks = [
        "t2_proxy"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.copyparty.entrypoints" = "https";
        "traefik.http.routers.copyparty.rule" = "Host(`copyparty.local`)";
        "traefik.http.routers.copyparty.tls" = "true";
        "traefik.http.services.cp.loadbalancer.server.port" = "3923";
      };
    };
  };
}
