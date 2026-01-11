{ pkgs, ... }:

{
  imports = [
    ./modules/dunst.nix
    ./modules/fastfetch.nix
    ./modules/git.nix
    ./modules/hypridle.nix
    ./modules/hyprland.nix
    ./modules/hyprlock.nix
    ./modules/hyprpaper.nix
    ./modules/kitty.nix
    ./modules/mpv.nix
    ./modules/setup_scripts.nix
    ./modules/vscode.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    ./modules/wofi.nix
    ./modules/zsh.nix
  ];

  home.username = "darthunder";
  home.homeDirectory = "/home/darthunder";
  home.stateVersion = "25.11";
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.packages = with pkgs; [
    zip
    unzip
    p7zip
    gcc
    gnumake
    clang-tools
    gnutar
    age

    kdePackages.ark
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kimageformats

    brave
    spotify
    discord
    onlyoffice-desktopeditors
    ffmpeg
    
    libnotify
    wl-clipboard
    kdePackages.dolphin
    cliphist
    hyprpaper
    
    networkmanagerapplet
    
    (prismlauncher.override {
      jdks = [
        zulu21
        zulu17
        zulu8
      ];
    })

    grim
    slurp
    swappy
    brightnessctl
    playerctl
    jq
    nixd

    eza
    zsh-powerlevel10k
    rclone
    pavucontrol
    gsimplecal

    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    zulu21
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 32;
  };

  programs.home-manager.enable = true;
}