{pkgs,inputs, ...}:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  niri-session = "${pkgs.niri-stable}/bin/niri-session";
in
{
#     imports = [ ./style.nix ./binds.nix ];
     programs.niri = {
       enable = true;
       package = pkgs.niri-stable;
     };
     services.greetd = {
        enable = true;
	settings = {
	  default_session = {
	    command = "${tuigreet} --time --remember --cmd ${niri-session}"; 
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
