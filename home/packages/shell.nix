{ pkgs, ... }:
{
  home.shell.enableBashIntegration = true;

  xdg.configFile."fish/themes".source = "${pkgs.localPkgs.fish-rose-pine}";
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
    };
    interactiveShellInit = ''
      fish_config theme choose "Rosé Pine"
      set -x LC_MESSAGES en_US.UTF-8
      set -x GPG_TTY $(tty)
    '';
    plugins = with pkgs.fishPlugins; [
      {
        name = "z";
        src = z.src;
      }
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "sudope";
        src = plugin-sudope.src;
      }
    ];
  };
}
