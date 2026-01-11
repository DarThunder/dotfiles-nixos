{ pkgs, ... }:

let
  esc = builtins.fromJSON "\"\\u001b\"";
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "kitty";
        source = "${../fastfetch/logo}/*.png"; 
        width = 40;
        height = 20;
        padding = {
          top = 2;
          left = 2;
          right = 2;
        };
      };
      display = {
        separator = " ${esc}[38;2;203;166;247m${esc}[0m ";
        constants = [ "${esc}[38;2;242;205;205m─────────────────${esc}[0m" ];
        key = {
          type = "icon";
          paddingLeft = 2;
        };
      };
      modules = [
        {
          type = "custom";
          format = "${esc}[38;2;242;205;205m┌${esc}[0m{$1}       ${esc}[38;2;203;166;247m 計算機${esc}[0m       {$1}${esc}[38;2;242;205;205m┐${esc}[0m";
        }
        { type = "host"; keyColor = "#f5c2e7"; }
        { type = "cpu"; keyColor = "#f5c2e7"; }
        { type = "gpu"; keyColor = "#f5c2e7"; }
        { type = "disk"; keyColor = "#f5c2e7"; }
        { type = "memory"; keyColor = "#f5c2e7"; }
        { type = "display"; keyColor = "#f5c2e7"; }
        {
          type = "custom";
          format = "${esc}[38;2;242;205;205m└${esc}[0m{$1}${esc}[38;2;242;205;205m──────────────────────${esc}[0m{$1}${esc}[38;2;242;205;205m┘${esc}[0m";
        }
        { type = "custom"; format = ""; }
        {
          type = "custom";
          format = "${esc}[38;2;242;205;205m┌${esc}[0m{$1}${esc}[38;2;203;166;247m darthunder@omnissiah${esc}[0m{$1}${esc}[38;2;242;205;205m┐${esc}[0m";
        }
        { type = "os"; keyColor = "#f5c2e7"; }
        { type = "kernel"; keyColor = "#f5c2e7"; }
        { type = "lm"; keyColor = "#f5c2e7"; }
        { type = "de"; keyColor = "#f5c2e7"; }
        { type = "wm"; keyColor = "#f5c2e7"; }
        { type = "shell"; keyColor = "#f5c2e7"; }
        { type = "terminal"; keyColor = "#f5c2e7"; }
        { type = "font"; keyColor = "#f5c2e7"; }
        { type = "theme"; keyColor = "#f5c2e7"; }
        { type = "icons"; keyColor = "#f5c2e7"; }
        { type = "packages"; keyColor = "#f5c2e7"; }
        { type = "uptime"; keyColor = "#f5c2e7"; }
        { type = "locale"; keyColor = "#f5c2e7"; }
        {
          type = "custom";
          format = "${esc}[38;2;242;205;205m└${esc}[0m{$1}${esc}[38;2;242;205;205m──────────────────────${esc}[0m{$1}${esc}[38;2;242;205;205m┘${esc}[0m";
        }
        {
          type = "colors";
          symbol = "circle";
          paddingLeft = 21;
        }
      ];
    };
  };
}