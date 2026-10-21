{ modules, ... }:
let
  nixosVersion = "26.05";
  hostName = "ice";
in
{
  imports =
    with modules.nixosModules;
    with system;
    with services;
    with packages;
    [
      users.root users.yuki

      droidspaces

      nix-ld nvim
  ];

  pref.home-manager.yuki = {
    enable = true;
    modules =
      with modules.homeModules;
      with packages;
      [
        component.shell

        ./home.nix
      ];
  };

  pref = {
    nix-cnmirror = true;
    nix-autogc = true;
    ssh-strict = true;
  };
}
// {
  nixpkgs.hostPlatform = "aarch64-linux";
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
