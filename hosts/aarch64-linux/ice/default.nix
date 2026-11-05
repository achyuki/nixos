{ modules, pkgs, ... }:
let
  nixosVersion = "26.05";
  hostName = "ice";
  patchedShadow = pkgs.shadow.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/su.c \
        --replace-fail 'if (!doshell || need_pty_prot) {' \
                       'if (!doshell || (need_pty_prot && !isatty (STDIN_FILENO))) {'
    '';
  });
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
      nix-ld comma nvim
      extpkgs
  ];

  pref.home-manager.yuki = {
    enable = true;
    modules =
      with modules.homeModules;
      with desktop;
      with packages;
      [
        components.shell
        devenv

        ./home.nix
      ];
  };

  pref = {
    nix-cnmirror = true;
    nix-autogc = false;
    ssh-strict = true;
  };

}
// {
  nixpkgs.hostPlatform = "aarch64-linux";
  security.shadow.su.package = patchedShadow.su;
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
