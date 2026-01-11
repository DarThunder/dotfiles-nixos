{ pkgs, ... }:
let
  waybarToggle = pkgs.writeShellScriptBin "waybar-toggle" ''
    #!/bin/sh
    if pgrep -x "waybar" > /dev/null; then
      pkill -SIGUSR2 waybar
    else
      ${pkgs.waybar}/bin/waybar &
    fi
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      
      "$active_border" = "rgba(FFC800ff)";
      "$active_border2" = "rgba(FF69B4ff)";
      "$inactive_border" = "rgba(280058ff)";
      "$text" = "rgba(FFFFFFff)";
      "$urgent" = "rgba(FF0000ff)";
      "$shadow_color" = "rgba(150f14ff)";

      env = [
        "XCURSOR_SIZE,32"
        "HYPRCURSOR_SIZE,32"
        "QT_SCALE_FACTOR,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "ELECTRON_ENABLE_NATIVE_WINDOW_OPEN,1"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_QPA_PLATFORM,wayland;xcb"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      input = {
        kb_layout = "latam, ru";
        kb_options = "grp:win_space_toggle";
        follow_mouse = 1;
        
        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 0;
        force_no_accel = 1;
        numlock_by_default = true;
      };

      gestures = {
        workspace_swipe_distance = 1000;
        "gesture" = "3, horizontal, workspace"; 
      };

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GNOME_KEYRING_CONTROL"
        "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.dunst}/bin/dunst"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
        "hypridle"
        "hyprlock"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.waybar}/bin/waybar"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        "col.active_border" = "$active_border $active_border2 45deg"; 
        "col.inactive_border" = "$inactive_border";

        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        rounding_power = 2;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1F1D19ee)";
        };

        blur = {
          enabled = true;
          size = 10;
          passes = 2;
          new_optimizations = true;
          contrast = 1.0;
          brightness = 1.0;
          noise = 0.015;
          vibrancy = 0.2;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 6, myBezier"
          "windowsIn, 1, 7, myBezier, slide"
          "windowsOut, 1, 7, default, slide"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      monitor = [
        "eDP-1, disable"
        "HDMI-A-1, 1920x1080@74.97, 0x0, 1.25"

        ", preferred, auto, 1"
      ];
    };

    extraConfig = ''
      $mainMod = Super

      $TERMINAL = kitty
      $MENU = wofi --show
      $EDITOR = code
      $EXPLORER = dolphin
      $BROWSER = brave --password-store=basic
      $OFFICE = onlyoffice-desktopeditors
      $MUSIC = spotify
      $MINECRAFT = prismlauncher
      $DISCORD = discord

      $wm=Window Management
      $d=[$wm]
      bindd = $mainMod, Q, exec, killactive
      bindd = $mainMod, Delete, $d kill hyprland session, exit
      bindd = $mainMod, W, $d toggle float, togglefloating
      bindd = $mainMod, G, $d toggle group, togglegroup
      bindd = $mainMod Shift, F, $d toggle fullscreen, fullscreen
      bindd = $mainMod, L, $d lock screen, exec, hyprlock
      bindd = $mainMod, Backspace, $d logout menu, exec, wlogout
      bindd = $mainMod Shift, Backspace, $d reboot system, exec, reboot
      bindd = $mainMod Control, Backspace, $d shutdown system, exec, shutdown now
      bind = $mainMod SHIFT, W, exec, waybar-toggle

      $d=[$wm|Group Navigation]
      bindd = $mainMod Control, H, $d change active group backwards, changegroupactive, b
      bindd = $mainMod Control, L, $d change active group forwards, changegroupactive, f

      $d=[$wm|Change focus]
      bindd = $mainMod, Left, $d focus left, movefocus, l
      bindd = $mainMod, Right, $d focus right, movefocus, r
      bindd = $mainMod, Up, $d focus up, movefocus, u
      bindd = $mainMod, Down, $d focus down, movefocus, d

      $d=[$wm|Resize Active Window]
      bindde = $mainMod Shift, Right, $d resize window right, resizeactive, 30 0
      bindde = $mainMod Shift, Left, $d resize window left, resizeactive, -30 0
      bindde = $mainMod Shift, Up, $d resize window up, resizeactive, 0 -30
      bindde = $mainMod Shift, Down, $d resize window down, resizeactive, 0 30

      $d=[$wm|Move active window across workspace]
      $moveactivewindow=grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive
      bindde = $mainMod Shift Control, left, Move activewindow to the right, exec, $moveactivewindow -30 0 || hyprctl dispatch movewindow l
      bindde = $mainMod Shift Control, right, Move activewindow to the right, exec, $moveactivewindow 30 0 || hyprctl dispatch movewindow r
      bindde = $mainMod Shift Control, up, Move activewindow to the right, exec, $moveactivewindow 0 -30 || hyprctl dispatch movewindow u
      bindde = $mainMod Shift Control, down, Move activewindow to the right, exec, $moveactivewindow 0 30 || hyprctl dispatch movewindow d

      $d=[$wm|Move & Resize with mouse]
      binddm = $mainMod, mouse:272, $d hold to move window, movewindow
      binddm = $mainMod, mouse:273, $d hold to resize window, resizewindow
      binddm = $mainMod, Z, $d hold to move window, movewindow
      binddm = $mainMod, X, $d hold to resize window, resizewindow

      $d=[$wm]
      bindd = $mainMod, J, $d toggle split, togglesplit

      $l=Launcher
      $d=[$l|Apps]
      bindd = $mainMod, T, $d terminal emulator, exec, $TERMINAL
      bindd = $mainMod, E, $d file explorer, exec, $EXPLORER
      bindd = $mainMod, C, $d text editor, exec, $EDITOR
      bindd = $mainMod, F, $d web browser, exec, $BROWSER
      bindd = $mainMod, R, $d libre office, exec, $OFFICE
      bindd = $mainMod, S, $d spotify, exec, $MUSIC
      bindd = $mainMod, M, $d minecraft, exec, $MINECRAFT
      bindd = $mainMod, D, $d discord, exec, $DISCORD

      $d=[$l|Rofi menus]
      bindd = $mainMod, A, $d application finder, exec, pkill -x wofi || $MENU drun
      bindd = $mainMod Shift, E, $d file finder, exec, pkill -x wofi || fd --type f | wofi --dmenu | xargs -r xdg-open
      bindd = $mainMod, V, hist finder, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy
      bindd = $mainMod SHIFT, V, hist wiper, exec, cliphist wipe

      $hc=Hardware Controls
      $d=[$hc|Audio]
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      $d=[$hc|Media]
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      $d=[$hc|Brightness]
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

      $ut=Utility
      $d=[$ut|Screen Capture]
      bind = $mainMod, P, exec, ( FINAL_DIR="$HOME/Pictures/"; FILE_NAME="screenshot-$(date +%Y%m%d-%H%M%S).png"; FINAL_PATH="$FINAL_DIR/$FILE_NAME"; TEMP_PATH="/tmp/$FILE_NAME"; AREA=$(slurp -d); if [[ -n "$AREA" ]]; then mkdir -p "$FINAL_DIR" && grim -g "$AREA" "$TEMP_PATH" && swappy -f "$TEMP_PATH" -o "$FINAL_PATH" & SWAPPY_PID=$! ; sleep 0.5 ; kill -0 $SWAPPY_PID 2>/dev/null && rm "$TEMP_PATH" ; wait $SWAPPY_PID 2>/dev/null ; if [[ -f "$FINAL_PATH" ]]; then notify-send "Captura Guardada" "Editada y guardada en $FINAL_PATH" -i "$FINAL_PATH"; else notify-send "Captura Cancelada" "La imagen no fue guardada."; fi; fi )
      bind = $mainMod SHIFT, P, exec, ( FILE="$HOME/Pictures/screenshot-$(date +%s).png" ; grim "$FILE" ; notify-send "Captura de Pantalla" "Guardada en $HOME/Pictures" -i "$FILE" )

      $ws=Workspaces
      $d=[$ws|Navigation]
      bindd = $mainMod, 1, $d navigate to workspace 1, workspace, 1
      bindd = $mainMod, 2, $d navigate to workspace 2, workspace, 2
      bindd = $mainMod, 3, $d navigate to workspace 3, workspace, 3
      bindd = $mainMod, 4, $d navigate to workspace 4, workspace, 4
      bindd = $mainMod, 5, $d navigate to workspace 5, workspace, 5
      bindd = $mainMod, 6, $d navigate to workspace 6, workspace, 6
      bindd = $mainMod, 7, $d navigate to workspace 7, workspace, 7
      bindd = $mainMod, 8, $d navigate to workspace 8, workspace, 8
      bindd = $mainMod, 9, $d navigate to workspace 9, workspace, 9
      bindd = $mainMod, 0, $d navigate to workspace 10, workspace, 10

      $d=[$ws|Navigation|Relative workspace]
      bindd = $mainMod Control, Right, $d change active workspace forwards, workspace, r+1
      bindd = $mainMod Control, Left, $d change active workspace backwards, workspace, r-1

      $d=[$ws|Navigation]
      bindd = $mainMod Control, Down, $d navigate to the nearest empty workspace, workspace, empty

      $d=[$ws|Move window to workspace]
      bindd = $mainMod Shift, 1, $d move to workspace 1, movetoworkspace, 1
      bindd = $mainMod Shift, 2, $d move to workspace 2, movetoworkspace, 2
      bindd = $mainMod Shift, 3, $d move to workspace 3, movetoworkspace, 3
      bindd = $mainMod Shift, 4, $d move to workspace 4, movetoworkspace, 4
      bindd = $mainMod Shift, 5, $d move to workspace 5, movetoworkspace, 5
      bindd = $mainMod Shift, 6, $d move to workspace 6, movetoworkspace, 6
      bindd = $mainMod Shift, 7, $d move to workspace 7, movetoworkspace, 7
      bindd = $mainMod Shift, 8, $d move to workspace 8, movetoworkspace, 8
      bindd = $mainMod Shift, 9, $d move to workspace 9, movetoworkspace, 9
      bindd = $mainMod Shift, 0, $d move to workspace 10, movetoworkspace, 10

      $d=[$ws]
      bindd = $mainMod Control+Alt, Right, $d move window to next relative workspace, movetoworkspace, r+1
      bindd = $mainMod Control+Alt, Left, $d move window to previous relative workspace, movetoworkspace, r-1

      $d=[$ws|Navigation]
      bindd = $mainMod, mouse_down, $d next workspace, workspace, e+1
      bindd = $mainMod, mouse_up, $d previous workspace, workspace, e-1

      $d=[$ws|Navigation|Move window silently]
      bindd = $mainMod Alt, 1, $d move to workspace 1 (silent), movetoworkspacesilent, 1
      bindd = $mainMod Alt, 2, $d move to workspace 2 (silent), movetoworkspacesilent, 2
      bindd = $mainMod Alt, 3, $d move to workspace 3 (silent), movetoworkspacesilent, 3
      bindd = $mainMod Alt, 4, $d move to workspace 4 (silent), movetoworkspacesilent, 4
      bindd = $mainMod Alt, 5, $d move to workspace 5 (silent), movetoworkspacesilent, 5
      bindd = $mainMod Alt, 6, $d move to workspace 6 (silent), movetoworkspacesilent, 6
      bindd = $mainMod Alt, 7, $d move to workspace 7 (silent), movetoworkspacesilent, 7
      bindd = $mainMod Alt, 8, $d move to workspace 8 (silent), movetoworkspacesilent, 8
      bindd = $mainMod Alt, 9, $d move to workspace 9 (silent), movetoworkspacesilent, 9
      bindd = $mainMod Alt, 0, $d move to workspace 10 (silent), movetoworkspacesilent, 10

      windowrule = match:class ^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$, tag +browser
      windowrule = match:class ^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$, tag +browser
      windowrule = match:class ^(chrome-.+-Default)$, tag +browser
      windowrule = match:class ^([Cc]hromium)$, tag +browser
      windowrule = match:class ^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$, tag +browser
      windowrule = match:class ^(Brave-browser(-beta|-dev|-unstable)?)$, tag +browser
      windowrule = match:class ^([Tt]horium-browser|[Cc]achy-browser)$, tag +browser
      windowrule = match:class ^(zen-alpha|zen)$, tag +browser

      windowrule = match:class ^(swaync-control-center|swaync-notification-window|swaync-client|class)$, tag +notif
      windowrule = match:title ^(KooL Quick Cheat Sheet)$, tag +KooL_Cheat
      windowrule = match:title ^(KooL Hyprland Settings)$, tag +KooL_Settings
      windowrule = match:class ^(nwg-displays|nwg-look)$, tag +KooL-Settings

      windowrule = match:class ^(Alacritty|kitty|kitty-dropterm)$, tag +terminal
      windowrule = match:class ^([Tt]hunderbird|org.gnome.Evolution)$, tag +email
      windowrule = match:class ^(eu.betterbird.Betterbird)$, tag +email
      windowrule = match:class ^(codium|codium-url-handler|VSCodium)$, tag +projects
      windowrule = match:class ^(VSCode|code|code-url-handler)$, tag +projects
      windowrule = match:class ^(jetbrains-.+)$, tag +projects
      windowrule = match:class ^(com.obsproject.Studio)$, tag +screenshare

      windowrule = match:class ^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$, tag +im
      windowrule = match:class ^([Ff]erdium)$, tag +im
      windowrule = match:class ^([Ww]hatsapp-for-linux)$, tag +im
      windowrule = match:class ^(ZapZap|com.rtosta.zapzap)$, tag +im
      windowrule = match:class ^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$, tag +im
      windowrule = match:class ^(teams-for-linux)$, tag +im
      windowrule = match:class ^(im.riot.Riot|Element)$, tag +im

      windowrule = match:class ^(gamescope)$, tag +games
      windowrule = match:class ^(steam_app_\\d+)$, tag +games
      windowrule = match:class ^([Ss]team)$, tag +gamestore
      windowrule = match:title ^([Ll]utris)$, tag +gamestore
      windowrule = match:class ^(com.heroicgameslauncher.hgl)$, tag +gamestore

      windowrule = match:class ^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$, tag +file-manager
      windowrule = match:class ^(app.drey.Warp)$, tag +file-manager
      windowrule = match:class ^([Ww]aytrogen)$, tag +wallpaper
      windowrule = match:class ^([Aa]udacious)$, tag +multimedia
      windowrule = match:class ^([Mm]pv|vlc)$, tag +multimedia_video

      windowrule = match:title ^(ROG Control)$, tag +settings
      windowrule = match:class ^(wihotspot(-gui)?)$, tag +settings
      windowrule = match:class ^([Bb]aobab|org.gnome.[Bb]aobab)$, tag +settings
      windowrule = match:class ^(gnome-disks|wihotspot(-gui)?)$, tag +settings
      windowrule = match:title (Kvantum Manager), tag +settings
      windowrule = match:class ^(file-roller|org.gnome.FileRoller)$, tag +settings
      windowrule = match:class ^(nm-applet|nm-connection-editor|blueman-manager)$, tag +settings
      windowrule = match:class ^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$, tag +settings
      windowrule = match:class ^(qt5ct|qt6ct|[Yy]ad)$, tag +settings
      windowrule = match:class (xdg-desktop-portal-gtk), tag +settings
      windowrule = match:class ^(org.kde.polkit-kde-authentication-agent-1)$, tag +settings
      windowrule = match:class ^([Rr]ofi)$, tag +settings

      windowrule = match:class ^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$, tag +viewer
      windowrule = match:class ^(evince)$, tag +viewer
      windowrule = match:class ^(eog|org.gnome.Loupe)$, tag +viewer

      windowrule = match:tag multimedia_video, no_blur on
      windowrule = match:tag multimedia_video, opacity 1.0

      windowrule = match:tag KooL_Cheat, center on
      windowrule = match:class ([Tt]hunar) match:title negative:(.*[Tt]hunar.*), center on
      windowrule = match:title ^(ROG Control)$, center on
      windowrule = match:tag KooL-Settings, center on
      windowrule = match:title ^(Keybindings)$, center on
      windowrule = match:class ^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$, center on
      windowrule = match:class ^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$, center on
      windowrule = match:class ^([Ff]erdium)$, center on
      windowrule = match:title ^(Picture-in-Picture)$, move 72% 7%

      windowrule = match:fullscreen true, idle_inhibit fullscreen

      windowrule = match:tag KooL_Cheat, float on
      windowrule = match:tag wallpaper, float on
      windowrule = match:tag settings, float on
      windowrule = match:tag viewer, float on
      windowrule = match:tag KooL-Settings, float on
      windowrule = match:class ([Zz]oom|onedriver|onedriver-launcher), float on
      windowrule = match:class (org.gnome.Calculator) match:title (Calculator), float on
      windowrule = match:class ^(mpv|com.github.rafostar.Clapper)$, float on
      windowrule = match:class ^([Qq]alculate-gtk)$, float on
      windowrule = match:class ^([Ff]erdium)$, float on
      windowrule = match:title ^(Picture-in-Picture)$, float on

      windowrule = match:title ^(Authentication Required)$, float on, center on
      windowrule = match:class (codium|codium-url-handler|VSCodium) match:title negative:(.*codium.*|.*VSCodium.*), float on
      windowrule = match:class ^(com.heroicgameslauncher.hgl)$ match:title negative:(Heroic Games Launcher), float on
      windowrule = match:class ^([Ss]team)$ match:title negative:^([Ss]team)$, float on
      windowrule = match:class ([Tt]hunar) match:title negative:(.*[Tt]hunar.*), float on

      windowrule = match:title ^(Add Folder to Workspace)$, float on, size (monitor_w*0.7) (monitor_h*0.6), center on
      windowrule = match:title ^(Save As)$, float on, size (monitor_w*0.7) (monitor_h*0.6), center on
      windowrule = match:initial_title (Open Files), float on, size (monitor_w*0.7) (monitor_h*0.6)
      windowrule = match:title ^(SDDM Background)$, float on, center on, size (monitor_w*0.16) (monitor_h*0.12)
      windowrule = match:class ^(yad)$ match:title ^(YAD)$, float on, center on, size (monitor_w*0.2) (monitor_h*0.2)

      windowrule = match:tag browser, opacity 0.99 0.8
      windowrule = match:tag projects, opacity 0.9 0.8
      windowrule = match:tag im, opacity 0.94 0.86
      windowrule = match:tag multimedia, opacity 0.94 0.86
      windowrule = match:tag file-manager, opacity 0.9 0.8
      windowrule = match:tag terminal, opacity 0.9 0.7
      windowrule = match:tag settings, opacity 0.8 0.7
      windowrule = match:tag viewer, opacity 0.82 0.75
      windowrule = match:tag wallpaper, opacity 0.9 0.7
      windowrule = match:class ^(gedit|org.gnome.TextEditor|mousepad)$, opacity 0.8 0.7
      windowrule = match:class ^(deluge)$, opacity 0.9 0.8
      windowrule = match:class ^(seahorse)$, opacity 0.9 0.8
      windowrule = match:title ^(Picture-in-Picture)$, opacity 0.95 0.75

      windowrule = match:tag KooL_Cheat, size (monitor_w*0.65) (monitor_h*0.9)
      windowrule = match:tag wallpaper, size (monitor_w*0.7) (monitor_h*0.7)
      windowrule = match:tag settings, size (monitor_w*0.7) (monitor_h*0.7)
      windowrule = match:class ^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$, size (monitor_w*0.6) (monitor_h*0.7)
      windowrule = match:class ^([Ff]erdium)$, size (monitor_w*0.6) (monitor_h*0.7)

      windowrule = match:title ^(Picture-in-Picture)$, pin on, keep_aspect_ratio on

      windowrule = match:tag games, no_blur on, fullscreen 0
      windowrule = match:tag games, fullscreen 0

      windowrule = match:class ^(jetbrains-*), no_initial_focus on
      windowrule = match:title ^(wind.*)$, no_initial_focus on

      layerrule = match:namespace rofi, blur on
      layerrule = match:namespace notifications, blur on
      layerrule = match:namespace quickshell:overview, blur on
      layerrule = match:namespace quickshell:overview, ignore_alpha 0.5
    '';
  };
}