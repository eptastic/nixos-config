{
  config,
  pkgs,
  ...
}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
  dockerDir = vars.system.dockerDir;
  localhost = vars.system.localhost;
  tz = vars.user.tz;
in {
  virtualisation.oci-containers.containers = {
    mosquitto = {
      image = "eclipse-mosquitto";
      autoStart = true;

      ports = ["1883:1883"];

      volumes = [
        "${dockerDir}/mosquitto/config:/config"
        "${dockerDir}/mosquitto/data:/data"
        "${dockerDir}/mosquitto/log:/log"
      ];
    };
  };
}
