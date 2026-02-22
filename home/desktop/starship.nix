{ lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$status"
        "$hostname"
        "$os"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_status"
        "$git_state"
        "$cmd_duration"
        "$fill"
        "$username"
        "$time"
        "$line_break"
        "$character"
      ];

      palette = lib.mkForce "monet";

      palettes = {
        monet = {
          primary = "#FFB4AB";
          secondary = "#BFC6DC";
          tertiary = "#C0CBAC";
          surface = "#A59C99";
        };
      };

      status = {
        disabled = false;
        format = "$symbol";
        success_symbol = "[╭](bold surface)";
        symbol = "[╭](bold red)";
      };

      character = {
        disabled = false;
        success_symbol = "[╰➜](bold surface)";
        error_symbol = "[╰➜](bold red)";
      };

      username = {
        disabled = true;
        style_user = "secondary";
        style_root = "secondary";
        format = "[$user]($style)";
        show_always = true;
      };

      hostname = {
        disabled = false;
        ssh_only = true;
        style = "bold surface";
        format = ''[\($hostname\)]($style)'';
      };

      os = {
        disabled = false;
        style = "primary";
        format = " [$symbol ]($style)";
        symbols = {
          AOSC = "";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Fedora = "󰣛";
          Gentoo = "󰣨";
          Linux = "󰌽";
          Macos = "󰀵";
          Manjaro = "";
          Mint = "󰣭";
          NixOS = "󱄅";
          Raspbian = "󰐿";
          RedHatEnterprise = "󱄛";
          Redhat = "󱄛";
          SUSE = "";
          Ubuntu = "󰕈";
          Windows = "";
        };
      };

      directory = {
        disabled = false;
        style = "bold primary";
        format = "[$path]($style)[$read_only]($style)";
        read_only = "  ";
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;
      };

      git_branch = {
        disabled = false;
        symbol = "󰘬 ";
        style = "secondary";
        format = " [$symbol$branch(:$remote_branch)]($style)";
      };

      git_commit = {
        disabled = false;
        style = "tertiary";
        tag_symbol = " ";
      };

      git_state = {
        disabled = false;
        style = "tertiary";
        format = ''[\($state( $progress_current/$progress_total)\)]($style)'';
      };

      git_status = {
        disabled = false;
        style = "tertiary";
      };

      cmd_duration = {
        disabled = false;
        style = "primary";
        format = " [󰪢 $duration]($style)";
        min_time = 3000;
      };

      fill = {
        disabled = false;
        symbol = " ";
      };

      time = {
        disabled = false;
        style = "primary";
        format = " at [  $time]($style)";
        time_format = "%H:%M";
        use_12hr = false;
      };

      package = {
        disabled = true;
      };
    };
  };
}
