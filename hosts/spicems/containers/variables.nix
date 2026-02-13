{
  user = {
    name = "alex";
    uid = "1000";
    pid = "1000";
    tz = "Australia/Melbourne";
  };

  system = {
    localhost = "172.16.20.50";

    dockerDir = "/home/alex/docker";
    sabDir = "/home/alex/docker/sabnzbd";
    acmeDir = "/home/alex/docker/traefik2/acme/acme.json";

    arrayDir = "/thufir2";
    mediaDir = "/thufir2/plex_media";
    slskd = "/thufir2/dj_music/slskd";
  };

  domain = {
    name = "spice.cx";
    nextcloud = "cloud.spice.cx";
  };

  nextcloud = {
    user = "nextcloud";
    database = "nextcloud";
  };

  cloudflare = {
    email = "cloudflare.cxsax@aleeas.com";
    ips = map builtins.toString [
      173.245.48.0/20
      103.21.244.0/22
      103.22.200.0/22
      103.31.4.0/22
      108.162.192.0/18
      190.93.240.0/20
      188.114.96.0/20
      197.234.240.0/22
      198.41.128.0/17
      162.158.0.0/15
      104.16.0.0/12
      172.64.0.0/13
      131.0.72.0/22
      141.101.64.0/18
      104.16.0.0/13
      104.24.0.0/14
    ];
  };

  local = {
    ips = map builtins.toString [
      172.0.0.1/32
      10.0.0.0/8
      192.168.0.0/16
      172.16.0.0/16
    ];
  };

  common = {
    logDriver = "journald";
    #    logDriver = "k8-file"; # Can't get it to work
  };
}
