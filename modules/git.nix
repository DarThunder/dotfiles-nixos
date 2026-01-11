{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "DarThunder";
        email = "diazcarazae@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}