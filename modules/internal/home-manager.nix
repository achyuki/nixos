{ config, inputs, modules, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    sharedModules = modules.homeModules._global;
    extraSpecialArgs = {
      inherit inputs;
      inherit (config) sops;
    };
  };

  # Link the portal definitions with the DE-provided configurations.
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
