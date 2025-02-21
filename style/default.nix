{pkgs,...}:
{
   systemd.user.services."swaybg" = {
       description = "swaybg";
       serviceConfig.PassEnvironment = "DISPLAY";
       script = "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.jpg}";
       wantedBy = [ "graphical.target" ];
   };
}
