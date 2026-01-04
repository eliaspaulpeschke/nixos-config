{pkgs,inputs, ...}:
let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  #niri-session = "${pkgs.niri-unstable}/bin/niri-session";
  sway = "${pkgs.sway}/bin/sway";
in
{
#     imports = [ ./style.nix ./binds.nix ];
     services.greetd = {
        enable = true;
	settings = {
	  default_session = {
	    command = "${tuigreet} --time --remember --cmd ${sway}"; 
	    user = "elias";
	  };
	};
     };

     systemd.services.greetd.serviceConfig = {
       Type = "idle";
       StandardInput = "tty";
       StandardOutput = "tty";
       StandardError = "journal";
       TTYReset = true;
       TTYVHangup = true;
       TTYVTDisallocate = true;
     };
}
