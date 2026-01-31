{
  config,
  secretsFile,
  ...
}: {
  sops = {
    defaultSopsFile = secretsFile;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops/age/keys.txt";

    secrets = {
      plex-claim = {
        key = "plex-claim";
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "cloudflare/apiKey" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/jwt" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/session-file" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/storage-encrypt" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/duo" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/mariadb/root-pass" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/mariadb/database" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/mariadb/user" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "authelia/smtp-password" = {};

      "nc/mysql-password" = {};
      "nc/mysql-root-password" = {};
      #      "nc/redis" = {};

      "mail-archiver/postgres-user" = {};
      "mail-archiver/postgres-password" = {};

      "paperless-admin-password" = {
        #owner = "paperless";
        #group = "paperless";
        #mode = "0400";
      };
    };
  };
}
