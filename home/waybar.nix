{ config, pkgs, lib, ...}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
       height = 30;
       layer = "top";
       position = "top";
       modules-center = [ "sway/window" ];
       modules-left = [ "sway/workspaces" ];
       modules-right = [ 
         "pulseaudio"
         "network"
	 "cpu"
	 "memory"
	 "battery"
	 "clock"
	 "tray"
	 ];
       pulseaudio = {
           format = "snd {icon} {volume}%";
           on-click = "pavucontrol";
       };
       battery = {
         format = "bat {capacity}%";
         format-charging = "charging {capacity}%";
         format-plugged = "plugged {capacity}%";
       };	 
       cpu = {
         format = "cpu {usage}%"; 
       };
       memory = {
         format = "mem {}%";
       };
       clock = {
         format-alt = "{:%Y-%m-%d}";
       };

    }];
  };
}
