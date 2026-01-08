{...}: {
  virtualisation.oci-containers.t2_proxy.networks = {
    driver = "bridge";
    #    external = true; # Apparently do not use this as it instructs podman not to create the network, it already exists.
  };
}
