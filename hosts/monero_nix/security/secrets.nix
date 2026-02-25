{config, ...}: {
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops/age/keys.txt";

    secrets = {
      "beszel/token" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "beszel/api-key" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "domain/name" = {
        #owner = "monero";
        #group = "monero";
        #mode = "0400";
      };
    };
  };
}
