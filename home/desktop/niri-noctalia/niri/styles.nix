{ config, ... }:
{
  programs.niri.settings = {
    layout = {
      background-color = "transparent";
      center-focused-column = "never";
      gaps = 4;
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];
      default-column-width.proportion = 0.5;

      focus-ring = {
        width = 2;
        active.color = "#d0bcff";
        inactive.color = "#948f99";
        urgent.color = "#f2b8b5";
      };
      shadow = {
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = "#00000070";
      };
      tab-indicator = {
        active.color = "#d0bcff";
        inactive.color = "#948f99";
        urgent.color = "#f2b8b5";
      };
      insert-hint.display.color = "#d0bcff80";

    };

    overview.workspace-shadow.enable = false;

    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 12.0;
          top-right = 12.0;
          bottom-left = 12.0;
          bottom-right = 12.0;
        };
        clip-to-geometry = true;
        tiled-state = true;
        draw-border-with-background = false;
      }
    ];
  };
}
