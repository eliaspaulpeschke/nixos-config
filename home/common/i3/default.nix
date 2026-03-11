{ config, pkgs, inputs, ... }: 
{
  home.packages = with pkgs; [ i3status ];
     
  xsession = { 
      enable = true;
      windowManager.i3 = {
          enable = true;
          config = null;
          extraConfig = builtins.readFile ./config + ''
          bindsym $mod+Return exec alacritty -e ${pkgs.tmux}/bin/tmux new-session -A -s main'';
      };
  };
}
