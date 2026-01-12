{ config, pkgs, lib, ... }:

let
  repoNames = [
    "iDar-Pacman-DB" "iDar-Pacman" "iDar-DB" "iDar-CryptoLib"
    "iDar-BigNum" "iDar-Codecs" "iDar-Structures" "iDar-Data"
  ];

  cloneCommands = pkgs.lib.concatMapStringsSep "\n" (repo: ''
    if [ ! -d "$HOME/Workshop/Github/${repo}" ]; then
      echo ">>> [GIT] Clonando ${repo}..."
      ${pkgs.git}/bin/git clone https://github.com/DarThunder/${repo}.git "$HOME/Workshop/Github/${repo}"
    fi
  '') repoNames;

in
{
  home.activation = {
    createDirectoryStructure = config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $HOME/Workshop/Github
      $DRY_RUN_CMD mkdir -p $HOME/Workshop/Projects
      $DRY_RUN_CMD mkdir -p $HOME/Documentos
      $DRY_RUN_CMD mkdir -p $HOME/My_space
    '';

    cloneGithubRepos = config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${pkgs.bash}/bin/bash -c '${cloneCommands}'
    '';
  };
}