{ pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = { };
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    ipc = on
    splash = false

    preload = ${../hypr/wallpapers/cinnamoroll-neon-3840x2160-11697.png}

    wallpaper {
      monitor =
      path = ${../hypr/wallpapers/cinnamoroll-neon-3840x2160-11697.png}
    }
  '';
}