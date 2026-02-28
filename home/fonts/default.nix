{ lib, stdenv }:
stdenv.mkDerivation rec {
    name = "Outfit";
    version = "1.0";

    src = lib.fileset.toSource {
        root = ./Outfit/static;
        fileset = ./Outfit/static;
        };

    phases = [ "installPhase" ];

    installPhase = ''
       mkdir -p $out/share/fonts/truetype/Outfit/
       for f in ${src}/*.ttf; do
         install -Dm644 $f $out/share/fonts/truetype/Outfit/ 
         install -Dm644 $f $out/share/fonts/truetype
       done
    '';
    
    meta = with lib; {
        description = "Outfit font";
        license = licenses.ofl;
        platforms = platforms.all;
    };
}
