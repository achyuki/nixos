{ pkgs, ... }:
{
  # https://github.com/sodiboo/niri-flake/blob/4f69ab280e9bb34e2c0b67fdfa6f0978a170ef56/flake.nix#L510-L522
  systemd.user.services.niri-flake-polkit = {
    description = "PolicyKit Authentication Agent provided by niri-flake";
    wantedBy = [ "niri.service" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
