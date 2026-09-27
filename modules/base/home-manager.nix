{
  config,
  inputs,
  modules,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    sharedModules = with modules.homeModules; (_global ++ [ base ]);
    extraSpecialArgs = {
      inherit inputs;
      inherit (config) age;
    };
  };

  # Link the portal definitions with the DE-provided configurations.
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
