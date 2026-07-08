{ config, lib, pkgs, inputs, ... }:

let
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.plymouth = {
    enable = true;
    theme = "boot_sequence";
    themePackages = [
      (pkgs.stdenv.mkDerivation {
        name = "plymouth-theme-boot-sequence";
        src = ./boot_sequence;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/plymouth/themes/boot_sequence
          cp -r * $out/share/plymouth/themes/boot_sequence
          # Esta línea cambia las rutas mágicamente al compilar:
          sed -i "s|/etc/plymouth/themes/boot_sequence|$out/share/plymouth/themes/boot_sequence|g" $out/share/plymouth/themes/boot_sequence/boot_sequence.plymouth
        '';
      })
    ];
  };
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
      background = "background_options/1.20 - [Trails & Tales].png";
      boot-options-count = 4;
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "omnissiah";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "es_MX.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "es_MX.UTF-8";
    LC_MONETARY = "es_MX.UTF-8";
  };

  programs.zsh.enable = true;
  users.users.darthunder = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "storage" "docker" "libvirtd" "kvm" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    docker-compose
    android-studio
    android-tools
    inputs.activate-linux.packages.${pkgs.system}.default
    vlc
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.flatpak = {
    enable = true;
    packages = [
      { appId = "org.vinegarhq.Sober"; origin = "flathub"; }
      { appId = "org.vinegarhq.Vinegar"; origin = "flathub"; }
    ];
  };
  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  }];
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland 
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.packageOverrides = pkgs: {
    openldap = pkgs.openldap.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };

  networking.firewall.enable = true;

  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  hardware.graphics = {
  enable = true;
  enable32Bit = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
      sansSerif = [ "Inter" "Noto Sans CJK JP" ];
      serif = [ "Noto Serif" "Noto Serif CJK JP" ];
    };
  };
  hardware.keyboard.qmk.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  system.activationScripts.binbash = {
  text = ''
    ln -sfn ${pkgs.bash}/bin/bash /bin/bash
  '';
  };
  virtualisation.docker = {
    enable = true;
    extraPackages = [ pkgs.docker-buildx ];
  };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
    ];
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
  ];

  systemd.user.services.adb = {
    description = "Start adb server";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.android-tools}/bin/adb start-server";
  };
  systemd.user.services.easyeffects = {
    description = "EasyEffects Daemon";
    requires = [ "dbus.service" ];
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" "pipewire.service" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      ExecStop = "${pkgs.easyeffects}/bin/easyeffects --quit";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 2;
    extraArgs = [
      "-g"
      "--prefer '^(java|minecraft|electron)$'"
      "--avoid '^(hyprland|Xorg|systemd)$'"
    ];
  };

  services.udev.packages = with pkgs; [
    via
    vial
    qmk-udev-rules
  ];

  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
  zramSwap.memoryPercent = 50;

  networking.firewall.allowedUDPPorts = [ 8080 1337 ];
  networking.firewall.allowedTCPPorts = [ 8080 ];

  system.stateVersion = "25.11";
}

