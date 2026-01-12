{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = false;
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
    extraGroups = [ "wheel" "networkmanager" "video" "render" "storage" "docker" ];
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
  ];

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

  nixpkgs.config.allowUnfree = true;

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

  system.stateVersion = "25.11";
}

