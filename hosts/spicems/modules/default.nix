{
  imports = [
    ./podman-runtime.nix
    #./docker-runtime.nix
    #./networks.nix
    #    ./paperless-ngx.nix
  ];

  #  homelab.services.paperless = {
  #    enable = true;
  #
  #    mediaDir = "/thufir2/paperless/documents";
  #    consumptionDir = "/thufir2/paperless/import";
  #    passwordFile = "/run/secrets/paperless-admin-password";
  #    url = "paperless.spice.cx";
  #    listenAddress = "172.16.20.50";
  #  };
}
