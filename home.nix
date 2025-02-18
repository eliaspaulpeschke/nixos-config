{ config, pkgs, inputs, ... }: 

{

  home.username = "elias";
  home.homeDirectory = "/home/elias";

  imports = [
     ./nixvim
     ];

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
    tmux
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

  programs.firefox = {
    enable = true;
  };

  
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

}

