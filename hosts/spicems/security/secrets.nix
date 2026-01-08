{
  sops.secrets."plex-claim" = {
    sopsFile = ../secrets/plex.yaml;
    key "plex-claim";
    owner = "root";
    group = "root";
    mode = "0400";
  };
}
