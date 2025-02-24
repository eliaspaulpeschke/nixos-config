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
       };
       Install = {

          WantedBy = [ "graphical-session.target" ];
       };
   };
}
