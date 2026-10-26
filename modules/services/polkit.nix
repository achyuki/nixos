{ lib, ... }: {
  security.polkit = {
    enable = true;
    # https://discourse.nixos.org/t/breaking-changes-announcement-for-unstable/17574/139
    enablePkexecWrapper = true;
    extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
    '';
  };

  security.soteria.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
