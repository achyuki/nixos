{ pkgs, ... }:
{
  environment.systemPackages = [
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs";
          runScript = "$SHELL";
        }
      )
    )
  ];
}
