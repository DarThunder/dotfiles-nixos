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

    restorePersonalData = config.lib.dag.entryAfter ["writeBoundary"] ''
      set -euo pipefail

      BACKUP_FILE="${../backup.tar.gz.age}"

      if [ -f "$BACKUP_FILE" ]; then
        if [ ! -d "$HOME/Workshop/Projects/Luxus" ]; then
          echo ">>> [RESTORE] Backup encriptado detectado. Iniciando protocolo de restauración..."

          echo -n "Ingrese passphrase de age: "
          read -s AGE_PASS
          echo

          TEMP_DIR=$(mktemp -d)
          trap 'rm -rf "$TEMP_DIR"' EXIT

          echo "$AGE_PASS" | ${pkgs.age}/bin/age -d "$BACKUP_FILE" | \
            ${pkgs.gnutar}/bin/tar -xz -C "$TEMP_DIR" --no-same-owner

          move_folder() {
            src=$1
            dest=$2
            if [ -d "$TEMP_DIR/$src" ]; then
              echo "  -> Restaurando $src en $dest..."
              $DRY_RUN_CMD cp -r "$TEMP_DIR/$src" "$dest/"
            fi
          }

          move_folder "iDar-CryptoLib-reimagined" "$HOME/Workshop/Github"
          move_folder "C++" "$HOME/Workshop/Projects"
          move_folder "Laniakea" "$HOME/Workshop/Projects"
          move_folder "Luxus" "$HOME/Workshop/Projects"
          move_folder "Dnd" "$HOME/Documentos"
          move_folder "noVer" "$HOME/Documentos"
          move_folder "UV" "$HOME/Documentos"
          move_folder "My_Space" "$HOME"

          if [ -f "id_ed25519" ] && [ -f "id_ed25519.pub" ]; then
            echo "  -> Restaurando SSH keys en ~/.ssh..."
            $DRY_RUN_CMD mkdir -p "$HOME/.ssh"
            $DRY_RUN_CMD chmod 700 "$HOME/.ssh"
            $DRY_RUN_CMD cp "id_ed25519" "$HOME/.ssh/id_ed25519"
            $DRY_RUN_CMD cp "known_hosts" "$HOME/.ssh/known_hosts"
            $DRY_RUN_CMD cp "id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
            $DRY_RUN_CMD chmod 600 "$HOME/.ssh/id_ed25519"
            $DRY_RUN_CMD chmod 644 "$HOME/.ssh/known_hosts"
            $DRY_RUN_CMD chmod 644 "$HOME/.ssh/id_ed25519.pub"
          fi

          echo ">>> [RESTORE] Restauración completada con éxito. (Passphrase borrada de memoria)"
        else
          echo ">>> [RESTORE] Sistema ya restaurado (Luxus detectado). Omitiendo."
        fi
      else
        echo ">>> [RESTORE] No se encontró $BACKUP_FILE. Saltando."
      fi
    '';

    cloneGithubRepos = config.lib.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${pkgs.bash}/bin/bash -c '${cloneCommands}'
    '';
  };
}