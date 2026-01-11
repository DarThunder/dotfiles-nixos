{ pkgs, ... }:

let
  jq = "${pkgs.jq}/bin/jq";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "weather-waybar" ''
      #!/usr/bin/env bash

      CITY="Xalapa"
      LANG="es"
      CACHE_FILE="''${HOME}/.cache/waybar-weather.json"
      CACHE_AGE=1800

      current_hour=$(date +%-H)
      if (( current_hour >= 19 || current_hour < 6 )); then
          is_night=true
      else
          is_night=false
      fi

      get_icon() {
        local code=$1
        
        case $code in
          113) # Sunny / Clear
            if [[ "$is_night" == "true" ]]; then echo " "; else echo " "; fi ;;
          
          116) # Partly Cloudy
            if [[ "$is_night" == "true" ]]; then echo " "; else echo " "; fi ;;
          
          119|122) echo " " ;;
          143|248|260) echo " " ;;
          176|263|266|281|284|293|296|353) echo "🌦" ;;
          179|323|326|368) echo "🌧" ;;
          200|386|389|392) echo "🌩" ;;
          227|230|320|329|332|335|338|350|371|374|395) echo "❄" ;;
          299|302|305|308|311|314|317|356|359|362|365|377) echo "🌧" ;;
          *) echo " " ;;
        esac
      }

      get_weather() {
        if [[ -f "$CACHE_FILE" && $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_AGE ]]; then
          cat "$CACHE_FILE"
          return
        fi

        local data
        data=$(curl -s --connect-timeout 10 "wttr.in/$CITY?format=j1&lang=$LANG")
        
        if [[ -n "$data" ]] && echo "$data" | ${jq} -e '.' >/dev/null 2>&1; then
          mkdir -p "$(dirname "$CACHE_FILE")"
          echo "$data" > "$CACHE_FILE"
          echo "$data"
        else
          [[ -f "$CACHE_FILE" ]] && cat "$CACHE_FILE" || echo "{}"
        fi
      }

      weather_data=$(get_weather)

      temp=$(echo "$weather_data" | ${jq} -r '.current_condition[0].temp_C // "N/A"')
      desc=$(echo "$weather_data" | ${jq} -r '.current_condition[0].weatherDesc[0].value? // "Unknon lol"')
      code=$(echo "$weather_data" | ${jq} -r '.current_condition[0].weatherCode // "0"')
      feels_like=$(echo "$weather_data" | ${jq} -r '.current_condition[0].FeelsLikeC // "?"')

      icon=$(get_icon "$code")

      if [[ "$temp" != "N/A" ]]; then
        ${jq} -n -c -M \
          --arg icon "$icon" \
          --arg temp "$temp" \
          --arg desc "$desc" \
          --arg feels "$feels_like" \
          --arg city "$CITY" \
          '{text: "\($icon) \($temp)°", tooltip: "\($desc)\nSensación: \($feels)°\n\($city)", class: "weather"}'
      else
        echo '{"text": " Offline", "tooltip": "Sin conexión", "class": "error"}'
      fi
    '')
  ];

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      height = 48;
      spacing = 0;
      layer = "top";
      position = "top";
      modules-left = [
        "custom/weather"
        "temperature"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
        "tray"
        "privacy"
        "network"
        "wireplumber"
        "battery"
        "clock"
      ];
      wireplumber = {
        format = "{icon}";
        format-muted = "󰸈";
        format-source = "";
        format-source-muted = "";
        on-click = "pavucontrol";
        on-hover = "{source}%";
        tooltip-format = "{volume}%";
        on-scroll-up = "volumectl -d +1%";
        on-scroll-down = "volumectl -d -1%";
        format-icons = {
          headphone = "󰋍";
          headset = "󰋍";
          phone = "";
          portable = "󰥰";
          car = "";
          default = [
            "󰕿"
            ""
            ""
          ];
        };
      };
      tray = {
        spacing = 4;
      };
      "custom/weather" = {
        format = "{}";
        return-type = "json";
        exec = "weather-waybar";
        interval = 1800;
        on-click = "notify-send 'Pronóstico Xalapa' \"$(curl -s 'wttr.in/Xalapa?0&lang=es' | head -7)\"";
        on-click-right = "rm -f ~/.cache/waybar-weather.json && pkill -RTMIN+8 waybar";
      };
      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon}";
        format-charging = " ";
        format-plugged = " ";
        tooltip-format = "{capacity}%";
        format-alt = "{icon} {time}";
        update-interval = 60;
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      clock = {
        format = "{:%a %d %H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        interval = 60;
      };
      bluetooth = {
        format = "";
        format-connected = "󰂱 {device_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
      };
      temperature = {
        critical-threshold = 90;
        format = "{icon} {temperatureC}℃";
        format-icons = [
          ""
          ""
          ""
        ];
        interval = 10;
      };
      network = {
        format-wifi = "{icon}";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        tooltip-format = "{essid}";
        format-ethernet = "󰈁";
        format-disconnected = "󰤫";
        format-disabled = "󰤭";
      };
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰸈";
        format-source = "";
        format-source-muted = "";
        on-click = "pavucontrol";
        on-hover = "{source}%";
        on-scroll-up = "volumectl -d +1%";
        on-scroll-down = "volumectl -d -1%";
        format-icons = {
          headphone = "󰋍";
          headset = "󰋍";
          phone = "";
          portable = "󰥰";
          car = "";
          default = [
            "󰕿"
            ""
            ""
          ];
        };
      };
      "hyprland/window" = {
        max-length = 80;
        format = "{}";
        tooltip = "{}";
        separate-outputs = true;
        on-click = "missioncenter";
      };
    };
    style = ''
      * {
          font-family: JetBrainsMono, Nerd Font;
          font-size: 14px;
      }

      window#waybar 
      {
          background-color: rgba(11, 11, 11, 0.35);
          border-radius: 0px;
          color: #FFFFFF;
          transition-property: background-color;
          transition-duration: .5s;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #tray,
      #mode,
      #window,
      #custom-vpn,
      #bluetooth,
      #privacy,
      #custom-weather,
      #wireplumber
      {
          padding: 0 10px;
          margin: 3px 0;
          margin-bottom: 8px;
          margin-top: 8px;
          color: rgba(11, 11, 13, 0.4998);
          border-radius: 10px;
      }

      #custom-notification
      {
        padding: 0 10px;
        margin: 0 0;
        color: rgba(11, 11, 13, 0.4998);
        border-radius: 10px;
      }

      #user
      {
        margin: 3px 0;
      }

      #cava 
      {
        margin: 3px 0;
        padding: 0 10px;
        border-radius: 10px;
      }

      #workspaces
      {
        padding: 0 5px;
        margin: 3px 0;
        color: #FFFFFF;
        border-radius: 5px;
      }

      #clock,
      #window,
      #workspaces,
      #battery,
      #cpu,
      #memory,
      #disk,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #temperature,
      #custom-notification,
      #custom-weather,
      #custom-playerlabel,
      #custom-playerctl.backward,
      #custom-playerctl.play,
      #custom-playerctl.forward,
      #custom-vpn,
      #bluetooth,
      #cava,
      #tray,
      #privacy,
      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power
      {
          background-color: rgba(11, 11, 13, 0.4998);
          color: #FFFFFF;
      }

      #tray menu
      {
        background-color: rgba(11, 11, 13, 0.49);
      }

      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power
      {
        padding: 10px;
      }

      #custom-quit
      {
        border-radius: 10px 0px 0px 10px;
      }

      #custom-reboot
      {
        border-radius: 0px 10px 10px 0px;
      }

      #tray
      {
        margin-right: 10px;
      }

      #custom-weather
      {
        margin: 3px 0px;
        margin-top: 8px;
        margin-bottom: 8px;
      }

      #clock 
      {
        margin-right: 5px;
      }

      #custom-power
      {
        margin-left: 10px;
        border-radius: 10px 0px 0px 10px;
      }

      #pulseaudio,
      #wireplumber
      {
        border-radius: 0px 0px 0px 10px;
        margin-left: 0px;
      }

      #custom-weather
      {
        border-radius: 10px 0px 0px 10px;
        margin-left: 10px;
      }

      #privacy
      {
        background-color: green;
        border-radius: 10px 10px 10px 10px;
        margin-left: 10px;
        margin-right: 10px;
      }

      #custom-vpn, 
      #bluetooth,
      #custom-airplane_mode
      {
        border-radius: 0px 0px 0px 0px;
        margin-left: 0px;
        margin-right: 0px;
        border-left: 0px;
        border-right: 0px;
      }

      #network 
      {
        border-radius: 10px 0px 0px 10px;
      }

      #battery 
      {
        border-radius: 0px 0px 0px 0px;
      }

      #clock 
      {
        border-radius: 0px 10px 10px 0px;
        margin-right: 10px;
      }

      #temperature
      {
        border-radius: 0px 10px 10px 0px;
      }

      #custom-cava 
      {
        background-color: rgba(46, 52, 64, 0.4998);
      }

      @keyframes fade_window_name
      {
        0% {
          background-color: rgba(59, 66, 82, 0.49);
        }
        50% {
          background-color: rgba(59, 66, 82, 0.32);
        }
        100% {
          background-color: rgba(59, 66, 82, 0.0);
        }
      }

      window#waybar.empty #window,
      window#privacy.empty #privacy
      {
          background-color: transparent;
      }

      #hyprland-window
      {
        font-family: AdwaitaSans, Nerd Font;
      }
    '';
  };
}