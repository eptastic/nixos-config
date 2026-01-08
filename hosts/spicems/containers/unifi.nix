{config, ...}: let
  vars = import ./variables.nix;
in {
  # Containers
  virtualisation.oci-containers.containers."unifi-controller" = {
    image = "lscr.io/linuxserver/unifi-controller:latest";
    environment = {
      MEM_LIMIT = "1024";
      MEM_STARTUP = "1024";
      PGID = vars.user.uid;
      PUID = vars.user.pid;
      TZ = vars.user.tz;
    };
    volumes = [
      "${vars.system.dockerDir}/unifi:/config:rw"
    ];
    ports = [
      "8443:8443/tcp"
      "3478:3478/udp"
      "10001:10001/udp"
      "8080:8080/tcp"
      "8843:8843/tcp"
      "8880:8880/tcp"
      "6789:6789/tcp"
      "5514:5514/udp"
    ];
    log-driver = vars.common.logDriver;
  };
}
