{pkgs,...}:
{
   systemd.user.services."swaybg" = {
       Unit = {
         Description = "swaybg";
       };
       Service = {
          Type = "simple";
          PassEnvironment = "DISPLAY";
          ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.jpg}";
	  Restart = "on-failure";
	  RestartSec = "10s";
       };
       Install = {

          WantedBy = [ "graphical-session.target" ];
       };
   };
}
