{
  config,
  pkgs,
  ...
}: let
  vars = import ./variables.nix;
  dockerDir = vars.system.dockerDir;
  domainName = vars.domain.name;
in {
  virtualisation.oci-containers.containers = {
    mailarchiver = {
      image = "s1t5/mailarchiver:latest";
      autoStart = true;

      ports = ["5000:5000"];

      volumes = [
        "${dockerDir}/mailarchiver/appsettings.json:/app/appsettings.json:ro"
        "${dockerDir}/mailarchiver/logs:/app/logs"
        "${dockerDir}/mailarchiver/data-protection-keys:/app/DataProtection-Keys"
      ];

      dependsOn = ["postgres"];

      extraOptions = [
        "--restart="
        "--network=mailarchiver-postgres"
      ];

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.mail-archiver-rtr.entrypoints" = "https";
        "traefik.http.routers.mail-archiver-rtr.rule" = "Host(`mail-archiver.${domainName}`)";
        "traefik.http.routers.mail-archiver-rtr.tls" = "true";
        "traefik.http.routers.mail-archiver-rtr.service" = "mail-archiver-svc";
        "traefik.http.services.mail-archiver-svc.loadbalancer.server.port" = "5000";
        "traefik.http.routers.mail-archiver-rtr.middlewares" = "chain-authelia@file";
      };
    };

    postgres = {
      image = "postgres:14-alpine";

      autoStart = true;

      environment = {
        POSTGRES_DB = "MailArchiver";
        POSTGRES_USER = "/run/secrets/mail-archiver/postgres-user";
        POSTGRES_PASSWORD = "/run/secrets/mail-archiver/postgres-password"; # ← consider using file or sops-nix instead!
      };

      volumes = [
        "${dockerDir}/postgres-data:/var/lib/postgresql/data"
      ];

      ports = []; # no external port mapping

      extraOptions = [
        "--restart="
        "--network=mailarchiver-postgres"
        "--health-cmd=pg_isready -U mailuser -d MailArchiver"
        "--health-interval=10s"
        "--health-timeout=5s"
        "--health-retries=5"
        "--health-start-period=10s"
      ];
    };
  };

  # Create a user-defined network (equivalent to the 'postgres' network in compose)
  systemd.services."podman-network-mailarchiver-postgres" = {
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.podman}/bin/podman network create mailarchiver-postgres";
      #ExecStop = "${pkgs.podman}/bin/podman network rm -f mailarchiver-postgres";
    };
    wantedBy = ["multi-user.target"];
    after = ["podman.service"];
    requires = ["podman.service"];
    partOf = ["podman-compose-mailarchiver-root.target"];
  };

  # Optional: make sure podman/docker starts early
  systemd.targets.podman-compose-mailarchiver = {
    wantedBy = ["multi-user.target"];
    after = ["podman-network-mailarchiver-postgres.service"];
    requires = ["podman-network-mailarchiver-postgres.service"];
  };

  systemd.services."podman-mail-archiver" = {
    after = ["zfs-import-thufir2.service" "zfs-mount.service"];
    requires = ["zfs-import-thufir2.service"];
  };
}
