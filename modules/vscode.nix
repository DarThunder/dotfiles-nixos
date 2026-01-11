{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscode-icons-team.vscode-icons
        llvm-vs-code-extensions.vscode-clangd
        esbenp.prettier-vscode
        sumneko.lua
        jnoortheen.nix-ide
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-java-test
        vscjava.vscode-maven
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "synthwave-vscode";
          publisher = "RobbOwen";
          version = "0.1.15";
          sha256 = "sha256-bcjUWB0/agSoFAsFdh1a+RYOF12J2XQY3GCv400+Pb4=";
        }
        {
          name = "indenticator";
          publisher = "SirTori";
          version = "0.7.0";
          sha256 = "sha256-J5iNO6V5US+GFyNjNNA5u9H2pKPozWKjQWcLAhl+BjY=";
        }
      ];
      
      userSettings = {
        "[cpp]" = {
          "editor.defaultFormatter" = null;
        };
        "[ruby]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[c]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
        };

        "breadcrumbs.enabled" = false;
        "editor.cursorBlinking" = "expand";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.fontSize" = 16;
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.glyphMargin" = false;
        "editor.guides.indentation" = false;
        "editor.hideCursorInOverviewRuler" = true;
        "editor.matchBrackets" = "never";
        "editor.minimap.enabled" = false;
        "editor.overviewRulerBorder" = false;
        "editor.scrollbar.horizontal" = "hidden";
        "editor.scrollbar.vertical" = "hidden";
        "editor.wordWrap" = "off";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        
        "files.autoSave" = "onWindowChange";
        "editor.formatOnPaste" = true;
        "explorer.confirmDelete" = false;
        "workbench.editor.empty.hint" = "hidden";
        "workbench.editor.showTabs" = "none";
        "workbench.activityBar.location" = "hidden";
        "workbench.statusBar.visible" = false;

        "workbench.colorTheme" = "SynthWave '84";
        "workbench.iconTheme" = "vscode-icons";
        "synthwave84.disableGlow" = false;
        "indenticator.color.dark" = "rgba(255,255,255,0.2)";
        "indenticator.width" = 0.1;
        
        "Lua.runtime.version" = "Lua 5.2";
        "Lua.diagnostics.globals" = [
          "bit" "colors" "colours" "commands" "disk" "fs" "gps" "help" "http" 
          "keys" "multishell" "paintutils" "parallel" "peripheral" "pocket" 
          "rednet" "redstone" "rs" "settings" "shell" "term" "textutils" 
          "turtle" "vector" "window" "_CC_DEFAULT_SETTINGS" "_HOST" 
          "printError" "write" "read" "sleep"
        ];
        "Lua.runtime.builtin" = {
          "bit32" = "enable";
          "bit" = "disable";
          "utf8" = "enable";
        };
        "Lua.diagnostics.disable" = [ "undefined-field" "deprecated" ];

        "prettier.enable" = true;
        "redhat.telemetry.enabled" = true;
        "clangd.arguments" = [ "--query-driver=${pkgs.gcc}/bin/gcc" ];
      };
    };
  };
}