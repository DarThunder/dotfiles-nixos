{ pkgs, ... }:

let
  lockCmd = "${pkgs.hyprlock}/bin/hyprlock";
  
  isDischarging = "[[ \"$(upower -i $(upower -e | grep 'BAT') | grep 'state' | awk '{print $2}')\" == \"discharging\" ]]";
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = lockCmd;
        unlock_cmd = "${pkgs.libnotify}/bin/notify-send \"unlock!\"";
        before_sleep_cmd = lockCmd;
        after_sleep_cmd = "${pkgs.libnotify}/bin/notify-send \"Awake!\"";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "if ${isDischarging}; then ${pkgs.brightnessctl}/bin/brightnessctl -s && ${pkgs.brightnessctl}/bin/brightnessctl s 1%; fi";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 120;
          on-timeout = "if ${isDischarging}; then ${lockCmd}; fi";
        }
        {
          timeout = 300;
          on-timeout = "if ${isDischarging}; then hyprctl dispatch dpms off; fi";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 500;
          on-timeout = "if ${isDischarging}; then systemctl suspend; fi";
        }
      ];
    };
  };
}