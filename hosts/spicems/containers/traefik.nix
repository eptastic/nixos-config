{
  config,
  pkgs,
  ...
}: let
  vars = import ./variables.nix;
  dockerDir = vars.system.dockerDir;
  domainName = vars.domain.name;
  cloudflareEmail = vars.cloudflare.email;
  cloudflareApiKey = "/run/secrets/cloudflare/apiKey";
  trustedIps = vars.cloudflare.ips ++ vars.local.ips; # list
  trustedIpsString = builtins.concatStringsSep "," trustedIps;
  acmeDir = vars.system.acmeDir;
in {
  virtualisation.oci-containers.containers = {
    traefik = {
      image = "felixbuenemann/traefik:v3.6";
      autoStart = true;

      cmd = [
        "--global.checkNewVersion=true"
        "--global.sendAnonymousUsage=true"
        "--entrypoints.http.address=:80"
        "--entrypoints.https.address=:443"

        #"--entrypoints.https.forwardedHeaders.trustedIPs=${trustedIpsString}"
        "--entrypoints.https.forwardedHeaders.trustedIPs=127.0.0.1/32,10.0.0.0/8,192.168.0.0/16,172.16.0.0/16,173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/12,172.64.0.0/13,131.0.72.0/22,141.101.64.0/18,104.16.0.0/13,104.24.0.0/14"
        "--entrypoints.traefik.address=:8282"
        "--api=true"
        "--api.insecure=true"
        "--log=true"
        "--log.level=WARN"
        "--accessLog=true"
        "--accessLog.filePath=/traefik.log"
        "--accessLog.bufferingSize=100"
        "--accessLog.filters.statusCodes=400-499"

        "--providers.docker=true"
        "--providers.docker.exposedByDefault=false"
        "--providers.docker.network=t2_proxy"

        "--providers.file.directory=/rules"
        "--providers.file.watch=true"

        "--entrypoints.https.http.tls.options=tls-opts@file"
        "--entrypoints.https.http.tls.certresolver=dns-cloudflare"
        "--entrypoints.https.http.tls.domains[0].main=${domainName}"
        "--entrypoints.https.http.tls.domains[0].sans=*.${domainName}"

        "--certificatesresolvers.dns-cloudflare.acme.email=${cloudflareEmail}"
        "--certificatesresolvers.dns-cloudflare.acme.storage=/acme/acme.json"
        "--certificatesresolvers.dns-cloudflare.acme.dnschallenge=true"
        "--certificatesresolvers.dns-cloudflare.acme.dnschallenge.provider=cloudflare"
        "--certificatesresolvers.dns-cloudflare.acme.dnschallenge.resolvers=1.1.1.1:53,1.0.0.1:53,172.16.10.1:53"
      ];
      #  ++
      #  # Repeated trustedIPs flags (one per CIDR)
      #  (map (ip: )
      #    (vars.cloudflare.ips ++ vars.local.ips));

      environment = {
        cf_api_email = cloudflareEmail;
        cf_api_key = cloudflareApiKey;
        domainname = domainName;
      };

      ports = [
        "80:80" # host http (test/mapping)
        "443:443" # host https
        "8282:8282" # traefik dashboard (insecure!)
        #"19132:19132/udp"  # if needed for some service
      ];

      networks = [
        "t2_proxy"
      ];

      volumes = [
        "${dockerDir}/traefik2/rules:/rules"
        "${dockerDir}/traefik2/rules/tls-opts.yml:/rules/tls-opts.yml"
        "/run/podman/podman.sock:/var/run/docker.sock" # podman needs podman socket compat if not using docker socket
        "${dockerDir}/traefik2/acme:/acme"
        "${dockerDir}/traefik2/certs:/certs:ro"
        "${dockerDir}/traefik2/traefik.log:/traefik.log"
        "${dockerDir}/shared:/shared"
      ];

      extraOptions = [
        "--network=t2_proxy" # REQUIRED - main proxy network
        # "--network=external_network"  # if needed
        "--security-opt=no-new-privileges:true"
      ];

      # labels for self-routing (traefik dashboard + http->https redirect)
      labels = {
        "traefik.enable" = "true";

        # http catchall redirect to https
        "traefik.http.routers.http-catchall.entrypoints" = "http";
        "traefik.http.routers.http-catchall.rule" = "hostregexp(`{host:.+}`)";
        "traefik.http.routers.http-catchall.middlewares" = "redirect-to-https";
        "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme" = "https";

        # traefik dashboard router
        "traefik.http.routers.traefik-rtr.entrypoints" = "https";
        "traefik.http.routers.traefik-rtr.rule" = "host(`traefik.${domainName}`)";
        "traefik.http.routers.traefik-rtr.tls" = "true";
        "traefik.http.routers.traefik-rtr.tls.domains[0].main" = domainName;
        "traefik.http.routers.traefik-rtr.tls.domains[0].sans" = "*.${domainName}";
        "traefik.http.routers.traefik-rtr.service" = "api@internal";

        # middleware chain (assuming chain-authelia is in /rules)
        "traefik.http.routers.traefik-rtr.middlewares" = "chain-authelia@file";
      };
    };
  };
  # optional: open host firewall ports (if not using host network)
  #networking.firewall.allowedtcpports = [80 443 8282 8617 4439];

  # ensure networks exist (podman creates them on first use, but declarative is better)
  systemd.services."podman-network-t2_proxy" = {
    description = "podman network t2_proxy";
    wantedBy = ["podman-traefik.service"];
    serviceConfig.type = "oneshot";
    script = ''
      ${config.virtualisation.podman.package}/bin/podman network create t2_proxy || true
    '';
  };
}
