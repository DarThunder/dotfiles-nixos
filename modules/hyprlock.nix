{ config, pkgs, ... }:

let
  tealAlpha = "8bd5ca";
  text = "rgb(cad3f5)";
  textAlpha = "cad3f5";
  base = "rgb(24273a)";
  surface0 = "rgb(363a4f)";
  sky = "rgb(8aadf4)";
  red = "rgb(ed8796)";
  yellow = "rgb(eed49f)";
  accentAlpha = tealAlpha;
  accent = "0xb3${accentAlpha}";
  font = "JetBrains Mono Regular";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = "${../hypr/wallpapers/cat_lofi_cafe.jpg}";
          blur_passes = 2;
          color = base;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:30000] echo \"$(date +\"%I:%M %p\")\"";
          color = text;
          font_size = 90;
          font_family = font;
          position = "-130, -100";
          halign = "right";
          valign = "top";
          shadow_passes = 2;
        }
        {
          monitor = "";
          text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
          color = text;
          font_size = 25;
          font_family = font;
          position = "-130, -250";
          halign = "right";
          valign = "top";
          shadow_passes = 2;
        }
        {
          monitor = "";
          text = "$LAYOUT";
          color = text;
          font_size = 20;
          font_family = font;
          position = "-130, -310";
          halign = "right";
          valign = "top";
          shadow_passes = 2;
        }
      ];

      image = [
        {
          monitor = "";
          path = "${../.face.png}";
          size = 350;
          border_color = accent;
          rounding = -1;
          position = "0, 75";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "400, 70";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = accent;
          inner_color = surface0;
          font_color = text;
          fade_on_empty = false;
          placeholder_text = "<span foreground=\"##${textAlpha}\"><i>󰌾 Logged in as </i><span foreground=\"##${accentAlpha}\">DarThunder</span></span>";
          hide_input = false;
          check_color = sky;
          fail_color = red;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = yellow;
          position = "0, -185";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }
      ];
    };
  };
}