{ pkgs, ... }:

{
  services.dunst = {
  enable = true;
  
  settings = {
    global = {
      width = 300;
      height = 100;
      offset = "5x5";
      origin = "top-right";
      gap_size = 7;
      notification_limit = 8;
      frame_width = 2;
      frame_color = "#cad3f5";
      separator_color = "frame";
      corner_radius = 10;
      font = "JetBrains Mono Regular 11"; 
      follow = "keyboard";
    };

    urgency_low = {
      background = "#24273A";
      foreground = "#CAD3F5";
    };

    urgency_normal = {
      background = "#24273A";
      foreground = "#CAD3F5";
    };

    urgency_critical = {
      background = "#24273A";
      foreground = "#CAD3F5";
      frame_color = "#F5A97F";
    };
  };
};
}