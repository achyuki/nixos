{ pkgs, ... }: {
  virtualisation = {
    containers = {
      enable = true;
      registries.settings = {
        registry = [
          { location = "docker.io"; }
          { location = "quay.io"; }
        ];
        unqualified-search-registries = [ "docker.io" ];
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = [ pkgs.podman-compose ];
}
