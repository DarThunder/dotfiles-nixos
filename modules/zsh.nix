{ pkgs, ... }:

{ 
  home.file.".p10k.zsh".source = ../.p10k.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      fastfetch --logo-type kitty 
    '';

    loginExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec start-hyprland
      fi
    '';

    shellAliases = {
      up = "cd ~/nix && sudo nixos-rebuild switch --flake .#omnissiah && cd -";
      test = "cd ~/nix && sudo nixos-rebuild dry-activate --flake /home/darthunder/nix#omnissiah && cd -";
      "in" = "nix shell nixpkgs#";
      ls = "eza";
      l = "eza -lh --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      c = "clear";
      vc = "code";
      fastfetch = "fastfetch --logo-type kitty";
    };
  };
}