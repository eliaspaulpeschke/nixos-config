{ config, pkgs, lib, ... }: 
let 
  dmenu-tmux = pkgs.callPackage ../dmenu-tmux.nix {lib = lib; config = config; };
in
{
  home.packages = with pkgs; [ i3status ];
  xsession = { 
      enable = true;
      windowManager.i3 = {
          enable = true;
          config = null;
          extraConfig = builtins.readFile ./config + ''
          bindsym $mod+Return exec alacritty -e ${pkgs.tmux}/bin/tmux new-session -A -s main
          bindsym $mod+BackSpace exec ${lib.getExe dmenu-tmux}
          bindsym $mod+$smod+BackSpace exec ${lib.getExe dmenu-tmux} kill'';
      };
  };
}
