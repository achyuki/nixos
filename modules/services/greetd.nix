{ config, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session.command =
      let
        inherit (config.services.displayManager.sessionData) desktops;
      in
      ''${pkgs.tuigreet}/bin/tuigreet --time --sessions ${desktops}/share/xsessions:${desktops}/share/wayland-sessions --remember --remember-user-session --asterisks --user-menu --greeting "Who TF Are You?" --cmd niri-session'';
  };
}
