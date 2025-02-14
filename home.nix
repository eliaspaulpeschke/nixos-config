{ config, pkgs, ... }: 

{

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  home.username = "elias";
  home.homeDirectory = "/home/elias";

  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

    ripgrep
    fzf

    dnsutils

    file
    which
    gnutar
    gnupg
 
    htop
    lsof
    pciutils
    usbutils

    lynx
  ];

  programs.git = {
    enable = true;
    userName = "Elias Peschke";
    userEmail = "eliaspeschke@googlemail.com";
  };

  programs.alacritty = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.nixvim = {
    enable = true; 
    luaLoader.enable = true;
    colorschemes.catpuccin.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

}

