{config, ...}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
      };
      "paperless-import" = {
        path = "/thufir2/paperless/import";
        browsable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  # Allows samba to advertise the shares to windows
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
