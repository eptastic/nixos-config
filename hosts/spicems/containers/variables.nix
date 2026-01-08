{
  user = {
    name = "alex";
    uid = "1000";
    pid = "1000";
    tz = "Australia/Melbourne";
  };

  system = {
    localhost = "172.16.20.5O";

    dockerDir = "/home/alex/docker";
    mediaDir = "/thufir2/plex_media";
    sabDir = "/home/alex/docker/sabnzbd";
    slskd = "/thufir2/dj_music/slskd";
  };

  domain = {
    name = "spice.cx";
    nextcloud = "cloud.spice.cx";
  };

  common = {
    logDriver = "journald";
  };
}
