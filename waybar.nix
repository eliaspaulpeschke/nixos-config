{ config, pkgs, lib, ...}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
       height = 30;
       layer = "top";
       position = "top";
       modules-center = [ "niri/window" ];
       modules-left = [ "niri/workspaces" ];
       modules-right = [ 
         "network"
	 "cpu"
	 "memory"
	 "clock"
	 "battery"
	 "tray"
	 ];
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
