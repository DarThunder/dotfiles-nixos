{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      hwdec = "auto-safe";
      save-position-on-quit = true;
    };
  };
}