{ pkgs, lib, ... }:
{
  # Let DMS manage its configuration.
  home.packages = [ pkgs.kitty ];
  /*
    programs.kitty = {
      enable = true;
      font.size = lib.mkForce 10;
      settings = {
        cursor_shape = "beam";
        cursor_trail = 1;

        window_padding_width = 12;
        confirm_os_window_close = 0;

        "map ctrl+c" = "copy_or_interrupt";
        "map page_up" = "scroll_page_up";
        "map page_down" = "scroll_page_down";
        "map ctrl+plus" = "change_font_size all +1";
        "map ctrl+minus" = "change_font_size all -1";
        "map ctrl+0" = "change_font_size all 0";
      };
    };
    stylix.targets.kitty.enable = true;
  */

}
