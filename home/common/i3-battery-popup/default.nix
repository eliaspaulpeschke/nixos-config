{ lib, stdenv, ...}:
stdenv.mkDerivation rec {
    name = "i3-battery-popup";
    version = "1.0";

    src = builtins.fetchGit { 
      url = "git@github.com:rjekker/i3-battery-popup.git"; 
      rev = "5d7a1ebbc2969acf35361129c09f0131ec372444";
      ref = "main"; 
    };

    phases = [ "installPhase" ];

    installPhase = ''
       mkdir -p $out/bin/
       install ${src}/i3-battery-popup $out/bin/
    '';
    
    meta = with lib; {
        description = "i3-battery-popup script";
        author = "rjekker";
        license = licenses.mit;
        platforms = platforms.all;
    };
}
