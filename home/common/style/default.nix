{pkgs,...}:
{
   systemd.user.services."background-image" = {
       Unit = {
         Description = "feh";
       };
       Service = {
          Type = "simple";
          PassEnvironment = "DISPLAY";
          ExecStart = "${pkgs.feh}/bin/feh --bg-scale ${./wallpaper.jpg}";
	  Restart = "on-failure";
	  RestartSec = "10s";
       };
       Install = {

          WantedBy = [ "graphical-session.target" ];
       };
   };
}
