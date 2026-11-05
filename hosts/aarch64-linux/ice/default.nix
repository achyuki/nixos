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
      with desktop;
      with packages;
      [
        components.shell

        ./home.nix
      ];
  };

  pref = {
    nix-cnmirror = true;
    nix-autogc = true;
    ssh-strict = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      shadow = prev.shadow.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/su.c \
            --replace-fail 'if (!doshell || need_pty_prot) {' \
                           'if (!doshell || (need_pty_prot && !isatty (STDIN_FILENO))) {'
        '';
      });
    })
  ];

}
// {
  nixpkgs.hostPlatform = "aarch64-linux";
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
