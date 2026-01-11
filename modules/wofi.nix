{ pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      hide_scroll=true;
      prompt="Launch";
      normal_window=true;
      no_actions=true;
      line_wrap="word";
      show-icons=true;
      width=550;
      height=335;
      allow_images=true;
      always_parse_args=true;
      show_all=false;
      term="kitty";
      insensitive=true;
      print_command=true;
      gtk_dark=false;
    };
    style = ''
      @define-color bg rgba(40, 0, 88, 0.85);
      @define-color accent #FFC800;
      @define-color accent2 #FF69B4;
      @define-color txt #FFFFFF;
      @define-color selected_bg rgba(58, 0, 112, 0.95);
      @define-color error #FF0000;

      * {
        font-family: "Iosevka Nerd Font mono";
        font-size: 14px;
      }

      window {
        background-color: @bg;
        border-radius: 15px;
        margin: 0px;
        padding: 0px;
        box-shadow: 0 0 15px 5px @accent;
      }

      #inner-box,
      #outer-box {
        margin: 0px;
        padding: 10px;
        border: none;
        background-color: transparent;
        border-radius: 10px;
      }

      #scroll {
        margin: 0px;
        padding: 0px;
        border: none;
      }

      #input {
        margin: 15px 15px 10px 15px;
        padding: 10px;
        color: @txt;
        background-color: @bg;
        border: 2px solid @accent;
        border-radius: 10px;
      }

      #text {
        margin: 0px 5px;
        padding: 8px 10px;
        border: none;
        color: @txt;
      }

      #entry:selected {
        background-color: @selected_bg;
        border: none;
        box-shadow: 0 0 5px 1px @accent2;
        border-radius: 10px;
      }

      #entry:selected #text {
        color: @accent2;
      }

      image {
        margin-left: 10px;
      }

      #input > image.right {
        -gtk-icon-transform: scaleX(0);
      }
    '';
  };
}