{ config, lib, ... }: {
  security.polkit = {
    enable = true;
    # https://discourse.nixos.org/t/breaking-changes-announcement-for-unstable/17574/139
    enablePkexecWrapper = true;
    extraConfig = lib.mkIf config.pref.sudo-strict ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
    '';
  };

  security.soteria.enable = true;
  systemd.user.services.polkit-soteria.environment.GSK_RENDERER = "cairo";
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
