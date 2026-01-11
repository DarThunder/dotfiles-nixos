{ pkgs, ... }:

let
  fntSize = "20";
  button_rad = "20";
  active_rad = "50";
  mgn = "20";
  hvr = "10";
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        keybind = "l";
        text = "Lock";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        keybind = "e";
        text = "Log-Out";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        keybind = "s";
        text = "Suspend";
      }
      {
        label = "reboot";
        action = "reboot";
        keybind = "r";
        text = "Reboot";
      }
      {
        label = "shutdown";
        action = "poweroff";
        keybind = "p";
        text = "Shut-Down";
      }
    ];
    style = ''
      /* Colores */
      @define-color main-bg #101419;
      @define-color wb-act-bg #93cee9;
      @define-color wb-hvr-bg #93cee9;

      * {
          background-image: none;
          font-size: ${fntSize}px;
      }

      window {
          background-color: transparent;
      }

      button {
          color: @wb-act-bg;
          background-color: @main-bg;
          outline-style: none;
          border: none;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          border-radius: 0px;
          box-shadow: none;
          text-shadow: none;
      }

      button:focus {
          background-color: @wb-act-bg;
          background-size: 30%;
      }

      button:hover {
          background-color: @wb-hvr-bg;
          background-size: 40%;
          border-radius: ${active_rad}px;
          transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
      }

      button:hover#lock { margin: ${hvr}px 0px ${hvr}px ${mgn}px; }
      button:hover#reboot { margin: ${hvr}px ${mgn}px ${hvr}px 0px; }
      button:hover#logout, button:hover#suspend, 
      button:hover#shutdown, button:hover#hibernate {
          margin: ${hvr}px 0px ${hvr}px 0px;
      }

      #lock {
          background-image: url("${../wlogout/icons/lock.png}");
          border-radius: ${button_rad}px 0px 0px ${button_rad}px;
          margin: ${mgn}px 0px ${mgn}px ${mgn}px;
      }
      #logout { 
          background-image: url("${../wlogout/icons/logout.png}");
          margin: ${mgn}px 0px ${mgn}px 0px;
      }
      #suspend { 
          background-image: url("${../wlogout/icons/suspend.png}");
          margin: ${mgn}px 0px ${mgn}px 0px;
      }
      #shutdown { 
          background-image: url("${../wlogout/icons/shutdown.png}");
          margin: ${mgn}px 0px ${mgn}px 0px;
      }
      #reboot {
          background-image: url("${../wlogout/icons/reboot.png}");
          border-radius: 0px ${button_rad}px ${button_rad}px 0px;
          margin: ${mgn}px ${mgn}px ${mgn}px 0px;
      }
    '';
  };
}