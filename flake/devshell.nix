{
  pkgs,
  ...
}:
{
  default = pkgs.mkShell {
    packages = with pkgs; [
      ssh-to-age
      sops
    ];
  };
}
