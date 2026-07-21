{
  config,
  pkgs,
  ...
}:
{
  users.users.root = {
    shell = pkgs.fish;
    hashedPasswordFile = config.sops.secrets.password00.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqNxUrlnSLf8Vr0RPOPydlwRltW0kMboxtxwLV/gBTV"
    ];
  };
  programs.fish.enable = true;
}
