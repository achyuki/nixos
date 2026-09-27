{ config, lib, ... }: {
  options.pref = {
    ssh-strict = lib.mkEnableOption "Disable password auth for openssh service.";
  };
  config = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = !config.pref.ssh-strict;
        KbdInteractiveAuthentication = !config.pref.ssh-strict;
        PermitRootLogin = "yes";
      };
    };
    programs.ssh.startAgent = true;
  };
}
